class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    stockpile = @hunter.stockpile
    stockpile.add
    respond_to do |format|
      format.json do
        render json: { stockpile: { cookies: @hunter.cookies } }
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
        render json: {
            hunters: [ { id: hunter.id, cookies: hunter.cookies} ],
            steal_bucket: { cookies: steal_bucket.cookies }
        }
      end
      format.html { redirect_to hunting_path }
    end
  end


end