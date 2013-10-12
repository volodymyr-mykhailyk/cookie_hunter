module Concurrency::LockStrategies
  class Plain
    def initialize(record)
    end

    def perform(options = {}, &block)
      yield
    end
  end
end