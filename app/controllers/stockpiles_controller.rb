class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    stockpile = @hunter.stockpile
    stockpile.add_what_should
    respond_to do |format|
      format.json do
        render json: { stockpile: { cookies: @hunter.cookies } }
      end
      format.html { redirect_to hunting_path }
    end
  end

  def steal
    hunter = Hunter.find(params[:hunter_id])
    steal = hunter.stockpile.remove_what_can(@hunter)
    steal_bucket = StealBucket.instance
    steal_bucket.add(-steal)
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