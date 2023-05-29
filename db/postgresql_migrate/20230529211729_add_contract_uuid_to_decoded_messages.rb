class AddContractUuidToDecodedMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :decoded_messages, :contract_uuid, :uuid, index: true
  end
end
