class ScheduleLatestTransactionsJob < ApplicationJob
  BUFFER_TIME = 1.minutes
  queue_as :transactions

  def perform
    Clickhouse::Venom::Devnet::Transaction
      .where('now >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .in_groups_of(10) do |batch|
        Venom::ProcessTransactionJob.perform_later(batch.compact)
      end
    Clickhouse::Everscale::Mainnet::Transaction
      .where('now >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .in_groups_of(10) do |batch|
        Everscale::ProcessTransactionJob.perform_later(batch.compact)
      end
  end
end
