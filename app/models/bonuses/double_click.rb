class Bonuses::DoubleClick < Bonuses::ClickBonus
  CLICKS = '*2' #should be the same as stockpile.clicks on creation
  BASIC_PRICE = 5000
  NAME = 'Double Click'

  def set_clicks
    self.clicks = stockpile.clicks
  end

  def price_for(stockpile)
    count = stockpile.bonus_count(self.class)
    self.class::BASIC_PRICE * (( 1 + count ) ** 2)
  end

end