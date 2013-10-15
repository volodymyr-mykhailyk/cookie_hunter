class BucketsController < ApplicationController
  before_filter :authenticate_hunter!


  def get
    steal_bucket = StealBucket.instance
    cookies_changed = steal_bucket.get_what_can(@hunter)
    @hunter.stockpile.add(-cookies_changed)

    respond_to do |format|
      format.json do
        render json: {
            stockpile: { cookies: @hunter.cookies },
            steal_bucket: { cookies: steal_bucket.cookies }
        }
      end
      format.html { redirect_to hunting_path }
    end
  end

end