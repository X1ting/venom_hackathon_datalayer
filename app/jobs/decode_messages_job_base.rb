class DecodeMessagesJobBase < SidekiqJob

  def perform(options)
    contract_ids = options["contract_ids"]
    try_to_decode_all = options["try_to_decode_all"]
    message_ids = options["message_ids"]

    if contract_ids
      contracts_scope = contract_base.where(id: contract_ids)
      contract_base.where(id: contract_ids).update_all(init_population_state: :in_progress)
    else
      contracts_scope = contract_base
    end

    if try_to_decode_all
      messages_scope = ch_module::Message
    else
      account_addresses = ch_module::Account.where(code_hash: contracts_scope.pluck(:code_hash)).select('distinct(id)')
      messages_scope = ch_module::Message.where(src: account_addresses).or(ch_module::Message.where(dst: account_addresses))
    end

    if message_ids
      messages_scope = messages_scope.where(id: message_ids)
    end

    messages_count = messages_scope.count

    return if messages_count.zero?

    offset = 0
    limit = 1000
    client = TonClient.create(config: { network: {endpoints: ["http://#{rpc_host}"]}})
    contracts_data = contracts_scope.pluck(:id, :abi)
    while offset <= messages_count
      results = []
      messages = messages_scope.limit(limit).offset(offset).select(:id, :boc, :src, :dst, :created_at)
      existing_messages_ids = DecodedMessage.where(ext_id: messages.map(&:id)).pluck(:ext_id)

      puts "Messages loaded, messsage count is: #{messages_count}"
      messages.each do |message|
        next if message.id.in?(existing_messages_ids)

        contracts_data.each do |(contract_id, abi)|
          payload = {
            abi: { type: 'Serialized', value: abi },
            message: message.boc
          }
          response = client.abi.decode_message_sync(payload)
          if response["result"]
            results.push({
              message: message,
              contract_id: contract_id,
              result: response["result"],
            })
          end
        end
      end
      results.each do |result|
        begin
          DecodedMessage.create(
            blockchain: blockchain,
            network: network,
            ext_id: result[:message].id,
            src: result[:message].src,
            dst: result[:message].dst,
            ext_created_at: result[:message].created_at,
            body_type: result[:result]["body_type"],
            name: result[:result]["name"],
            value: result[:result]["value"],
            header: result[:result]["header"],
            contract_uuid: result[:contract_id],
          )
        rescue ActiveRecord::RecordNotUnique => e
          puts e
        end
      end

      addresses = results.map {|result| [result[:message].src, result[:message].dst]}.uniq.flatten.compact_blank
      process_account_job.perform_async(addresses)
      offset = offset + limit
    end

    if contract_ids
      contract_base.where(id: contract_ids).update_all(init_population_state: :done)
    end
  end
end
