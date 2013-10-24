class HuntingsController < ApplicationController
  before_filter :authenticate_hunter!
  after_filter :bonus_double_request_lock

  def show
    @hunting = Hunting.new(@hunter)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @hunting.to_json }
    end
  end

  private

  def bonus_double_request_lock
    redis.setnx(lock_key('bonus_double_request'), 'flag')
  end

end