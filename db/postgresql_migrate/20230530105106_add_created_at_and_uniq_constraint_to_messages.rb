class AddCreatedAtAndUniqConstraintToMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :decoded_messages, [:ext_id, :blockchain, :network, :contract_uuid], unique: true, name: 'uniq_per_blockchain_and_contract'
    add_column :decoded_messages, :ext_created_at, :datetime, index: true
  end
end
