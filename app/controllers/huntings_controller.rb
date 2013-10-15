class HuntingsController < ApplicationController
  before_filter :authenticate_hunter!


  def show
    @hunting = Hunting.new(@hunter)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @hunting.to_json }
    end
  end

end