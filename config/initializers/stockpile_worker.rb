unless defined?(Rake) || defined?(Sidekiq::CLI)
  queue =  Sidekiq::ScheduledSet.new
  queue.each do |job|
    if job.klass == 'StockpileWorker'
      puts 'Delete'
      job.delete
    end

  end
  StockpileWorker.perform_in(5)
end