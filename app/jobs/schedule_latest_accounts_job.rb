class ScheduleLatestAccountsJob < ApplicationJob
  BUFFER_TIME = 3.minutes
  queue_as :accounts

  def perform
    Clickhouse::Venom::Devnet::Account
      .where('created_at_local >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .in_groups_of(50) do |batch|
        Venom::ProcessAccountsJob.perform_later(batch.compact)
      end
    Clickhouse::Everscale::Mainnet::Account
      .where('created_at_local >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .in_groups_of(50) do |batch|
        Everscale::ProcessAccountsJob.perform_later(batch.compact)
      end
  end
end
