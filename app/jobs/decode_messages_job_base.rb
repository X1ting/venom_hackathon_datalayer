class DecodeMessagesJobBase < ApplicationJob
  queue_as :messages

  def perform(contract_ids: nil, try_to_decode_all: false, message_ids: nil)
    contract = contract_base.find(contract_id)

    if try_to_decode_all
      messages_scope = ch_module::Message
    else
      account_addresses = ch_module::Account.where(code_hash: contract.code_hash).select('distinct(id)')
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
    abi = contract.abi
    while offset <= messages_count
      results = []
      messages = messages_scope.limit(limit).offset(offset).select(:id, :boc, :src, :dst, :created_at)

      messages.each do |message|
        payload = {
          abi: { type: 'Serialized', value: abi },
          message: message.boc
        }
        response = client.abi.decode_message_sync(payload)
        if response["result"]
          results.push({
            message: message,
            result: response["result"],
          })
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
            contract_uuid: contract.id,
          )
        rescue ActiveRecord::RecordNotUnique => e
          puts e
        end
      end

      offset = offset + limit
    end
  end
end
    #Venom::DecodeMessagesJob.perform_now(Contract.order(:created_at).last.id)
