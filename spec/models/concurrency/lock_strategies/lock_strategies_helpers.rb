def get_bucket(target)
  bucket = Bucket.find_by_id(target.id)
  bucket.stub(:change_lock_strategy => @current_strategy.new(bucket))
  bucket
end

def add_cookies(amount, target = @bucket)
  bucket = get_bucket(target)
  bucket.add(amount)
end

def transfer_cookies(amount = 2)
  bucket = get_bucket(@bucket)
  target = get_bucket(@target)
  bucket.transfer_from(target, amount)
end

def concurrency_test(method, tester)
  self.send(method, [1, 2, 3]) { |args| self.send(tester, args) }
end

def several_threads_test(tester)
  several_threads([1, 2, 3]) { |args| self.send(tester, args) }
end

def several_processes_test(tester)
  several_processes([1, 2, 3]) { |args| self.send(tester, args) }
end

def delay_execution(by_time = 0.3)
  Cookable.stub(:change_testing_hook).and_return { sleep(by_time) }
end

def delay_transfer(by_time = 0.3)
  Cookable.stub(:transfer_testing_hook).and_return { sleep(by_time) }
end