class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    stockpile = @hunter.stockpile
    stockpile.add
    respond_to do |format|
      format.json do
        render json: { result: :success, cookies: @hunter.cookies }
      end
      format.html { redirect_to hunting_path }
    end
  end

  def steal
    hunter = Hunter.find(params[:hunter_id])
    hunter.stockpile.remove
    steal_bucket = StealBucket.instance
    steal_bucket.add
    respond_to do |format|
      format.json do
        render json: { result: :success, cookies: hunter.cookies,
                       steal_bucket_cookies: steal_bucket.cookies}
      end
      format.html { redirect_to hunting_path }
    end
  end


end