Thread.new do
  EM.run do
    EM::PeriodicTimer.new(1) do
      Stockpile.find_each {|sp| sp.add}
    end
  end

end