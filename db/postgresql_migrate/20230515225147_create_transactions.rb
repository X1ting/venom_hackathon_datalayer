class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false, primary_key: :tx_id do |t|
      t.string :tx_id
      t.string :from
      t.string :to
      t.integer :kind
      t.datetime :time
      t.timestamps

      t.index :tx_id, unique: true
      t.index :from
      t.index :to
      t.index :time
    end
  end
end
