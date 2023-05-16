require 'sidekiq-scheduler'

class SidekiqJob
  include Sidekiq::Job
end
