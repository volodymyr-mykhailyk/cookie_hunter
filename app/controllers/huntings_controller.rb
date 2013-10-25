class HuntingsController < ApplicationController
  include DoubleRequestProtected

  before_filter :authenticate_hunter!
  after_filter :double_request_lock

  def show
    @hunting = Hunting.new(@hunter)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @hunting.to_json }
    end
  end

end