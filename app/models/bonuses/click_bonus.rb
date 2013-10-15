class Bonuses::ClickBonus < Bonuses::Bonus

  TYPES = [
      Bonuses::PlusClick,
      Bonuses::DoubleClick
  ]

  validates_presence_of :clicks

  delegate :recalculate_clicks, to: :stockpile
  after_save :recalculate_clicks

  before_save :set_clicks

  def value
    self.class::CLICKS
  end

end