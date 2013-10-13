def single_thread(&block)
  Thread.new(&block).join
end

def several_threads(arguments = 4.times.map, &block)
  running = arguments.map { |argument| sleep(0.01); Thread.new(argument, &block) }
  running.each { |thread| thread.join }
end
