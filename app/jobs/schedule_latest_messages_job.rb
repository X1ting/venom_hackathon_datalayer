class ScheduleLatestMessagesJob < ApplicationJob
  BUFFER_TIME = 1.minute
  queue_as :messages

  def perform
    Clickhouse::Venom::Devnet::Message
      .where('created_at >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .compact_blank
      .in_groups_of(50) do |batch|
        Venom::DecodeMessagesJob.perform_async({
          "message_ids" => batch.compact,
          "try_to_decode_all" => true
        })
      end

    Clickhouse::Everscale::Mainnet::Message
      .where('created_at >= ?', BUFFER_TIME.ago)
      .pluck(:id)
      .uniq
      .compact_blank
      .in_groups_of(50) do |batch|
        Everscale::DecodeMessagesJob.perform_async({
          "message_ids" => batch.compact,
          "try_to_decode_all" => true
        })
      end
  end
end
