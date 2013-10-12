module Concurrency
  module RedisCooldown
    include RedisCommon

    def cooldown(name, cooldown_time = 1)
      return verify_lock(lock_key(name)) unless obtain_cooldown(lock_key(name), cooldown_time)

      yield
    end

    protected
    def obtain_cooldown(name, cooldown_time)
      lock_end_time = (Time.now.to_f + cooldown_time + 1)
      redis.set(name, lock_end_time, {px: cooldown_time, nx: true})
    end
  end
end