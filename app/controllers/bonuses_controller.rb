class BonusesController < ApplicationController
  include DoubleRequestProtected

  before_filter :authenticate_hunter!
  before_filter :check_double_request, only: :buy

  def buy
    if Bonuses::Bonus.types.map(&:to_s).include?(params[:type])
      @hunter.stockpile.buy_bonus(params[:type].constantize)
    end
    respond_to do |format|
      format.html { redirect_to hunting_path }
    end
  end

end