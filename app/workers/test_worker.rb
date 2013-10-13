class TestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    StealBucket.instance.add
    TestWorker.perform_in(5)
  end

end