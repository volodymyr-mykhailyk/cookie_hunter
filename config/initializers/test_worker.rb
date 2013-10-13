unless defined?(Rake) || defined?(Sidekiq::CLI)
  queue =  Sidekiq::ScheduledSet.new
  queue.each do |job|
    if job.klass == 'TestWorker'
      puts 'Delete'
      job.delete
    end

  end
  TestWorker.perform_in(5)
end