module Venom
  class DecodeMessagesJob < DecodeMessagesJobBase
    include BaseJobMixin
    sidekiq_options :queue => :decode_messages_venom
    sidekiq_throttle(concurrency: { limit: 8 })
  end
end
