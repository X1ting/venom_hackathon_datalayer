class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string   :address
      t.integer  :network
      t.integer  :blockchain
      t.integer  :base_currency
      t.integer  :kind
      t.json     :latest_full_state
      t.datetime :latest_full_state_updated_at

      t.index :address

      t.timestamps
    end
  end
end
