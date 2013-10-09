Thread.new do
  EM.run do
    EM::PeriodicTimer.new(10) do
      puts '='*100
      Rails.logger.info 'Tick'
    end
  end

end