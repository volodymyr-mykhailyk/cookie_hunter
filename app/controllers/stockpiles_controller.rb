class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    @hunter.add_what_should
    respond_to do |format|
      format.json do
        render json: { stockpile: { cookies: @hunter.cookies } }
      end
      format.html { redirect_to hunting_path }
    end
  end

  def steal
    hunter = Hunter.find(params[:hunter_id])
    hunter.steal_by(@hunter)
    respond_to do |format|
      format.json do
        render json: {
            hunters: [ { id: hunter.id, cookies: hunter.cookies} ],
            steal_bucket: { cookies: StealBucket.instance.cookies }
        }
      end
      format.html { redirect_to hunting_path }
    end
  end
end