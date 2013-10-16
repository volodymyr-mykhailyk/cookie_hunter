class Bonuses::PlusClick < Bonuses::ClickBonus
  CLICKS = 1
  BASIC_PRICE = 1000
  NAME = 'Plus Click'
  DESCRIPTION = "#{CLICKS} more cookie per click"

  def set_clicks
    self.clicks = self.class::CLICKS
  end

end