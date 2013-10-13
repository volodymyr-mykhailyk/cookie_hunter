class Concurrency::LockStrategies::PessimisticWait

  def initialize(record)
    @record = record
  end

  def perform(options = {}, &block)
    @record.with_lock do
      yield
    end
  end
end

