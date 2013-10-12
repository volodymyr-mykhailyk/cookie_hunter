class Concurrency::LockStrategies::Redis
  include Concurrency::RedisLocking

  def initialize(record)
    @lock_key = record.id
  end

  def perform(options = {}, &block)
    lock(@lock_key, &block)
  end

end