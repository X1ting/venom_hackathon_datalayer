class DecodeMessagesJobBase < SidekiqJob

  def perform(options)
    Rails.logger.info('Start')
    stats = ActiveRecord::Base.connection_pool.stat
    Rails.logger.info("Connection pool stat: #{stats}")
    contract_ids = options["contract_ids"]
    try_to_decode_all = options["try_to_decode_all"]
    message_ids = options["message_ids"]
    contracts_scope = Contract.all
    if contract_ids
      contracts_scope = contracts_scope.where(id: contract_ids)
      contracts_scope.where(id: contract_ids).update_all(init_population_state: :in_progress)
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
    Rails.logger.info('Scopes defined')
    return if messages_count.zero?
    offset = 0
    limit = 1000
    client = TonClient.create(config: { network: {endpoints: ["http://#{rpc_host}"]}})
    Rails.logger.info('Client loaded')
    contracts_data = contracts_scope.pluck(:id, :abi)
    Rails.logger.info("Contracts loaded, count: #{contracts_data.count}")
    while offset <= messages_count
      to_insert = []
      messages = messages_scope.limit(limit).offset(offset).select(:id, :boc, :src, :dst, :created_at).distinct
      Rails.logger.info("Messages loaded, messsage count is: #{messages_count}")

      existing_messages_ids = DecodedMessage.where(ext_id: messages.map(&:id)).pluck(:ext_id).uniq
      Rails.logger.info("Existing messages loaded, messsage count is: #{existing_messages_ids.count}")

      messages.each do |message|
        next if message.id.in?(existing_messages_ids)
        Rails.logger.info("Processing #{message.id}")

        contracts_data.each do |(contract_id, abi)|
          payload = {
            abi: { type: 'Serialized', value: abi },
            message: message.boc
          }
          response = client.abi.decode_message_sync(payload)
          if response["result"]
            to_insert.push({
              blockchain: blockchain,
              network: network,
              ext_id: message.id,
              src: message.src,
              dst: message.dst,
              ext_created_at: message.created_at,
              body_type: response["result"]["body_type"],
              name: response["result"]["name"],
              value: response["result"]["value"],
              header: response["result"]["header"],
              contract_uuid: contract_id,
            })
          end
        end
      end

      Rails.logger.info("All decoding, saving, #{to_insert.count}")

      DecodedMessage.insert_all(to_insert) unless to_insert.empty?

      Rails.logger.info("All saved, scheduling accounts")

      addresses = to_insert.map {|result| [result[:src], result[:dst]]}.uniq.flatten.compact_blank
      process_account_job.perform_async(addresses)
      offset = offset + limit
    end

    Rails.logger.info("Done")
    if contract_ids
      contracts_scope.where(id: contract_ids).update_all(init_population_state: :done)
    end
  end
end
