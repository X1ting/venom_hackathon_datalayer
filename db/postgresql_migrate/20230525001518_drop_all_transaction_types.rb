class DropAllTransactionTypes < ActiveRecord::Migration[7.0]
  def change
    Transaction.update_all(kind: Transaction.kinds[:unknown])
  end
end
