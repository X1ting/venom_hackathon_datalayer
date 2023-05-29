class DecodeAllMessagesJobBase < ApplicationJob
  queue_as :messages

  def perform(contract_id)
    contract = contract_base.find(contract_id)
    messages_count = ch_module::Message.count
    return if messages_count.zero?

    offset = 0
    limit = 1000
    client = TonClient.create(config: { network: {endpoints: ["http://#{rpc_host}"]}})
    abi = contract.abi
    while offset <= messages_count
      results = []
      messages = ch_module::Message.limit(limit).offset(offset).select(:id, :boc, :src, :dst)

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
        DecodedMessage.create(
          blockchain: blockchain,
          network: network,
          ext_id: result[:message].id,
          src: result[:message].src,
          dst: result[:message].dst,
          body_type: result[:result]["body_type"],
          name: result[:result]["name"],
          value: result[:result]["value"],
          header: result[:result]["header"],
          contract_uuid: contract.id,
        )
      end

      offset = offset + limit
    end
  end
end
    #Venom::DecodeMessagesJob.perform_now(Contract.order(:created_at).last.id)
