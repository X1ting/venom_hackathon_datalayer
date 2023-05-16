class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :transactions, id: :uuid do |t|
      t.string :tx_id
      t.string :from
      t.string :to
      t.integer :kind
      t.integer :blockchain
      t.integer :network
      t.datetime :time
      t.timestamps

      t.index :tx_id
      t.index :from
      t.index :to
      t.index :time
    end
  end
end
