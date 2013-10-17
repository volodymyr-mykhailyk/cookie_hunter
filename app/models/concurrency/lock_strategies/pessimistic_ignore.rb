class Concurrency::LockStrategies::PessimisticIgnore

  def initialize(record)
    @record = record
  end

  #obtain lock with nowait option. in case of lock retrievement error return false
  def perform(options = {}, &block)
    @record.transaction do
      @record.class.lock('FOR UPDATE NOWAIT').find(@record.id)
      yield
    end
  rescue
    nil
  end
end

