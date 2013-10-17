def single_process(*args, &block)
  with_reconnect do
    process_id = run_in_process(*args, &block)
    Process.waitpid process_id
  end
end

def several_processes(arguments = 4.times.map, &block)
  with_reconnect do
    running = arguments.map { |args| sleep(0.01); run_in_process(args, &block) }
    running.each { |process_id| Process.waitpid(process_id) }
  end
end

def run_in_process(*args, &block)
  fork do
    with_reconnect(*args, &block)
  end
end

def with_reconnect(*args, &block)
  begin
    REDIS.client.reconnect
    spec       = Rails.application.config.database_configuration[Rails.env]
    ActiveRecord::Base.establish_connection(spec)
    yield(*args)
  ensure
    ActiveRecord::Base.connection.close
  end
end
