class BonusesController < ApplicationController
  before_filter :authenticate_hunter!

  def buy
    if Bonuses::Bonus.types.map(&:to_s).include?(params[:type])
      @hunter.stockpile.buy_bonus(params[:type].constantize)
      respond_to do |format|
        format.html { redirect_to hunting_path }
      end
    else
      render nothing: true
    end
  end
end