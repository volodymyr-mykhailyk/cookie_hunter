
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end
Sidekiq.configure_server do |config|
  config.redis = { :size => 5 }
  config.poll_interval = 1
end


unless defined?(Rake) || defined?(Sidekiq::CLI)
  if Rails.env.production?
    fork { spawn('bundle exec sidekiq') }
  end
end