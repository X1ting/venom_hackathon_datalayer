class CreateDecodedMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :decoded_messages, id: :uuid do |t|
      t.integer :blockchain
      t.integer :network
      t.string :ext_id
      t.string :src
      t.string :dst
      t.string :body_type
      t.string :name
      t.json   :value
      t.json   :header

      t.index :ext_id
      t.index :src
      t.index :dst
      t.index :name

      t.timestamps
    end
  end
end
