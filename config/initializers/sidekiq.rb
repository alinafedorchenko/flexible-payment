sidekiq_config = ENV['REDIS_URL'] || 'redis://redis:6379/0'

Sidekiq.configure_server do |config|
  config.redis = {
    url: sidekiq_config,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: sidekiq_config,
  }
end
