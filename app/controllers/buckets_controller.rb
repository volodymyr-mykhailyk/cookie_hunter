class BucketsController < ApplicationController
  include SpammingProtected

  before_filter :authenticate_hunter!
  request_cooldown_filter :bucket_response, 'getting_from_bucket', 100

  def get
    steal_bucket = StealBucket.instance
    @hunter.get_from(steal_bucket)

    bucket_response
  end

  private
  def bucket_response
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