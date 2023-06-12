require "sidekiq/throttled"
Sidekiq::Throttled.setup!

Sidekiq.configure_server do |config|
  redis = Rails.env.production? ? Rails.application.credentials.redis.hostname : 'redis://localhost:6379/1'
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  redis = Rails.env.production? ? Rails.application.credentials.redis.hostname : 'redis://localhost:6379/1'
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
end
