class BucketsController < ApplicationController
  before_filter :authenticate_hunter!


  def get
    steal_bucket = StealBucket.instance
    steal_bucket.remove
    stockpile = @hunter.stockpile
    stockpile.add
    respond_to do |format|
      format.json do
        render json: { result: :success,
                       hunter_cookies: @hunter.cookies,
                       steal_bucket_cookies: steal_bucket.cookies }
      end
      format.html { redirect_to hunting_path }
    end
  end

end