class BonusesController < ApplicationController
  before_filter :authenticate_hunter!
  before_filter :check_bonus_lock, only: :buy

  def buy
    if Bonuses::Bonus.types.map(&:to_s).include?(params[:type])
      @hunter.stockpile.buy_bonus(params[:type].constantize)
    end
    respond_to do |format|
      format.html { redirect_to hunting_path }
    end
  end

  private

  def check_bonus_lock
    unless redis.del(lock_key('bonus_double_request')) == 1
      redirect_to hunting_path
    end
  end

end