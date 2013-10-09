class StockpilesController < ApplicationController
  before_filter :authenticate_hunter!

  def add
    stockpile = @hunter.stockpile
    stockpile.add
    render json: { result: :success, cookies: stockpile.cookies}
  end


end