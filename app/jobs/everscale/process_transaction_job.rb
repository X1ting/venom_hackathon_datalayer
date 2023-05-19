module Everscale
  class ProcessTransactionJob < ApplicationJob
    queue_as :transactions

    def perform(tx_ids)
      ch_transactions = Clickhouse::Everscale::Mainnet::Transaction.where(id: tx_ids)
      existing_pg_transactions_ids = Transaction.everscale.mainnet.where(tx_id: tx_ids).pluck(:tx_id)
      ch_transactions.each do |ch_transaction|
        next if existing_pg_transactions_ids.include?(ch_transaction.id)

        Transaction.create!(
          tx_id: ch_transaction.id,
          from: ch_transaction.account_addr,
          to: ch_transaction.account_addr,
          time: ch_transaction.now,
          kind: Transaction.kinds.values.sample,
          blockchain: :everscale,
          network: :mainnet
        )
      end
    end
  end
end
