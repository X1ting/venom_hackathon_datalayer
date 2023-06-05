class ScheduleLatestTransactionsJob < ApplicationJob
  BUFFER_TIME = 3.minutes
  queue_as :transactions

  def perform
    Clickhouse::Venom::Devnet::Transaction
      .where('now >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .in_groups_of(50) do |batch|
        Venom::ProcessTransactionJob.perform_async(batch.compact)
      end
    Clickhouse::Everscale::Mainnet::Transaction
      .where('now >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .in_groups_of(50) do |batch|
        Everscale::ProcessTransactionJob.perform_async(batch.compact)
      end
  end
end
