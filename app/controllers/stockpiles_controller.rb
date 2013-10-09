class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    stockpile = @hunter.stockpile
    stockpile.add
    render json: { result: :success, cookies: stockpile.cookies }
  end

  def steal
    hunter = Hunter.find(params[:hunter_id])
    hunter.stockpile.remove
    render json: { result: :success, cookies: hunter.stockpile.cookies }
  end


end