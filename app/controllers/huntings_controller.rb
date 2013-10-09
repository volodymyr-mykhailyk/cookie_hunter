class HuntingsController < ApplicationController
  before_filter :authenticate_hunter!


  def show
    @hunter
  end

end