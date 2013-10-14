class StockpileWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Stockpile.regenerate_cookies
    StockpileWorker.perform_in(Stockpile::REGENERATION_TIME)
  end

end