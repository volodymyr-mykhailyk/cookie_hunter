redis_url = Rails.configuration.redis_url || ENV['REDISTOGO_URL']
config = URI.parse(redis_url)
REDIS = Redis.new(:host => config.host, :port => config.port, :password => config.password)