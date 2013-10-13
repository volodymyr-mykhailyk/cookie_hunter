def single_thread(&block)
  run_in_thread(&block).join
end

def several_threads(arguments = 4.times.map, &block)
  running = arguments.map { |argument| sleep(0.01); run_in_thread(argument, &block) }
  running.each { |thread| thread.join }
end

def run_in_thread(*args, &block)
  Thread.new(*args) do |*args|
    begin
      yield(*args)
    ensure
      #close connection after running in thread. otherwise pool is depleted by stalled connections
      ActiveRecord::Base.connection.close
    end
  end
end

