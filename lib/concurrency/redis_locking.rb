module Concurrency
  module RedisLocking
    attr_reader :record_lock

    def lock(name, lock_time = 10.seconds, &block)
      lock_key = lock_key(name)
      return verify_lock(lock_key) unless obtain_lock(lock_key, lock_time)

      begin
        yield
      ensure
        return_lock(lock_key)
      end
    end

    protected
    def redis
      REDIS
    end

    def lock_key(name)
      "redis_#{name}_lock"
    end

    # return true if lock obtained or false if already exists
    def obtain_lock(name, lock_time)
      lock_end_time = (Time.now.to_f + lock_time + 1)
      redis.set(name, lock_end_time, {ex: lock_time, nx: true})
    end

    #check if key not corrupted and removing it expiration.
    # current call should be failed anyway
    def verify_lock(name)
      return false if Time.now.to_f < redis.get(name).to_f
      redis.del(name)
      false
    end

    #removes lock after block executed
    #WARNING: Locking Integrity can be damaged if execution took longer then lock timeout.
    # Should remove only locks set by current call
    def return_lock(name)
      redis.del(name)
    end
  end
end