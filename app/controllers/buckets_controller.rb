class BucketsController < ApplicationController
  before_filter :authenticate_hunter!


  def get
    steal_bucket = StealBucket.instance
    @hunter.get_from(steal_bucket)

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