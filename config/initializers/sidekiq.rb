redis_url = ENV['REDIS_URL'] || 'redis://redis:6379'

if redis_url
  require 'sidekiq/middleware/i18n'

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }
  end
end
