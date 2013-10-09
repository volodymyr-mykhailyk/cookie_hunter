class StockpilesController < ApplicationController


  def add
    stockpile = @hunter.stockpile
    stockpile.add
    redirect_to hunting_path
  end


end