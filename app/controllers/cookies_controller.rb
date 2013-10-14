class CookiesController < ApplicationController
  before_filter :authenticate_hunter!

  def show
    steal_bucket_cookies = StealBucket.instance.cookies
    respond_to do |format|
      format.json { render json: { result: 'success',
                                   cookies: @hunter.cookies,
                                   steal_bucket_cookies: steal_bucket_cookies } }
      format.html { redirect_to hunting_path }
    end
  end
end