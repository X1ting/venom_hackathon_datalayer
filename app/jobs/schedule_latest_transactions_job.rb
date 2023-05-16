class ScheduleLatestTransactionsJob < ApplicationJob
  BUFFER_TIME = 1.minutes
  queue_as :transactions

  def perform
    Clickhouse::Venom::DevNet::Transaction
      .where('now >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .in_groups_of(10) do |batch|
        ProcessTransactionJob.perform_later(batch.compact)
      end
  end
end
