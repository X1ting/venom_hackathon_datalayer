module Everscale
  class DecodeMessagesJob < DecodeMessagesJobBase
    include BaseJobMixin
    sidekiq_options :queue => :decode_messages

    sidekiq_throttle(concurrency: { limit: 1 })
  end
end
