module Concurrency
  module RedisLocking
    include Concurrency::RedisCommon

    def lock(name, lock_time = 10.seconds)
      lock_key = lock_key(name)
      return verify_lock(lock_key) unless obtain_lock(lock_key, lock_time)

      begin
        yield
      ensure
        return_lock(lock_key)
      end
    end

    protected
    # return true if lock obtained or false if already exists
    def obtain_lock(name, lock_time)
      lock_end_time = (Time.now.to_f + lock_time + 1)
      redis.set(name, lock_end_time, {ex: lock_time, nx: true})
    end
  end
end