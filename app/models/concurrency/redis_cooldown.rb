module Concurrency::RedisCooldown
  include Concurrency::RedisCommon

  def cooldown(name, cooldown_time = 1)
    return verify_lock(lock_key(name)) unless obtain_cooldown(lock_key(name), cooldown_time)

    yield
  end

  protected
  def obtain_cooldown(name, cooldown_time)
    lock_end_time = (Time.now.to_f + cooldown_time + 1)
    if redis.method(:set).arity == 3
      redis.set(name, lock_end_time, {px: cooldown_time, nx: true})
    else
      #  workaround for heroku old redis
      #locks are not working properly in this mode
      return false unless redis.setnx(name, lock_end_time)
      redis.expire(name, cooldown_time)
      true
    end
  end
end