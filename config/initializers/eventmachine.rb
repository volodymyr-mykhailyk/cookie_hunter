Thread.new do
  EM.run do
    EM::PeriodicTimer.new(10) do
      Rails.logger.info '='*100
      Rails.logger.info 'Tick'
    end
  end

end