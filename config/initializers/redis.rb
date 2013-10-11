config = URI.parse(Rails.configuration.redis_url)
REDIS = Redis.new(:host => config.host, :port => config.port, :password => config.password)