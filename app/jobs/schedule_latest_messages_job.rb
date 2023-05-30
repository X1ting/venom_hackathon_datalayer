class ScheduleLatestMessagesJob < ApplicationJob
  BUFFER_TIME = 5.minutes
  queue_as :messages

  def perform
    Clickhouse::Venom::Devnet::Message
      .pluck(:id)
      .uniq
      .compact_blank
      .in_groups_of(50) do |batch|
        Venom::DecodeMessagesJob.perform_later(message_ids: batch, try_to_decode_all: true)
      end
  end
end
