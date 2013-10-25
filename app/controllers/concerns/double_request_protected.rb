module DoubleRequestProtected
  def double_request_lock
    REDIS.setnx(lock_key('double_request_id'), 'flag')
  end

  def check_double_request
    unless REDIS.del(lock_key('double_request_id')) == 1
      redirect_to hunting_path
    end
  end

end