def single_process(&block)
  ActiveRecord::Base.connection.disconnect!
  process_id = fork_process(&block)
  Process.waitpid process_id
  puts ActiveRecord::Base.connection.active?
  ActiveRecord::Base.connection.reconnect!
end

def several_processes(count = 5, &block)
  begin
    running = count.times.map { fork_process(&block) }
    running.each { |process_id| Process.waitpid(process_id) }
    ActiveRecord::Base.connection.reconnect!
  rescue
    ActiveRecord::Base.connection.reconnect!
    # ignored
  end
end

def fork_process(&block)
  fork do
    REDIS.client.reconnect
    ActiveRecord::Base.connection.reconnect!
    block.call
    ActiveRecord::Base.connection.disconnect!
  end
end