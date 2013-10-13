class BonusesController < ApplicationController
  before_filter :authenticate_hunter!

  def buy
    binding.pry
  end
end