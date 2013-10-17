module Concurrency
  module RedisCommon

    protected
    def redis
      REDIS
    end

    def lock_key(name)
      "redis_#{name}_lock"
    end

    #check if key not corrupted and removing it expiration.
    # current call should be failed anyway
    def verify_lock(name)
      return nil if Time.now.to_f < redis.get(name).to_f
      redis.del(name)
      nil
    end

    #removes lock after block executed
    #WARNING: Locking Integrity can be damaged if execution took longer then lock timeout.
    # Should remove only locks set by current call
    def return_lock(name)
      redis.del(name)
    end
  end
end