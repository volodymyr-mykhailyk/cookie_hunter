def single_thread(&block)
  Thread.new(&block).join
end

def several_threads(count = 5, &block)
  running = count.times.map { Thread.new(&block) }
  running.each { |thread| thread.join }
end