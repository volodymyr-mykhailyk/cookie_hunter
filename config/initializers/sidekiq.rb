
Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end
Sidekiq.configure_server do |config|
  config.redis = { :size => 5 }
end

unless defined?(Rake) || defined?(Sidekiq::CLI)
  fork do
    spawn('bundle exec sidekiq')
  end

end