module Concurrency::RedisLocking
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
    if redis.method(:set).arity == 3
      redis.set(name, lock_end_time, {ex: lock_time, nx: true})
    else
      #workaround for heroku old redis
      #locks are not working properly in this mode
      return false unless redis.setnx(name, lock_end_time)
      redis.pexpire(name, lock_time)
      true
    end
  end
end