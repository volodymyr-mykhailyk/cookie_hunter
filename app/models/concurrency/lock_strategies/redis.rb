class Concurrency::LockStrategies::Redis
  include Concurrency::RedisLocking

  def initialize(record)
    @lock_key = "#{record.class.name.underscore}_#{record.id}"
  end

  def perform(options = {}, &block)
    lock(@lock_key, &block)
  end

end