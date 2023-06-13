class AddIndexesToTimestamps < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    add_index :decoded_messages, :ext_created_at, algorithm: :concurrently
    add_index :accounts, :created_at, algorithm: :concurrently
    add_index :transactions, :time, algorithm: :concurrently
  rescue => e
    puts "#{e} happened!"
  end
end
