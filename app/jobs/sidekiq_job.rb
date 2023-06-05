require 'sidekiq-scheduler'
class SidekiqJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Job
end
