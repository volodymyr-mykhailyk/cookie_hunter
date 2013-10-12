module Concurrency
  module RedisLocking
    attr_reader :record_lock

    def lock(name, lock_time = 10.seconds, &block)
      return false unless obtain_lock(lock_key(name), lock_time)

      begin
        yield
      ensure
        return_lock(lock_key(name))
      end
    end

    protected
    def redis
      REDIS
    end

    def lock_key(name)
      "redis_#{name}_lock"
    end

    def lock_time_end(lock_time)
      Time.now.to_f + lock_time
    end

    def obtain_lock(name, lock_time)
      transaction_result = redis.multi do
        redis.setnx(name, lock_time_end(lock_time))
        redis.expire(name, lock_time)
      end
      transaction_result[0]
    end

    def return_lock(name)
      redis.del(name)
    end
  end
end