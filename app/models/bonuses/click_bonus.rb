class Bonuses::ClickBonus < Bonuses::Bonus

  def self.types
    [
        Bonuses::PlusClick,
        Bonuses::DoubleClick
    ]
  end

  validates_presence_of :clicks

  delegate :recalculate_clicks, to: :stockpile
  after_save :recalculate_clicks

  before_save :set_clicks

  def value
    self.class::CLICKS
  end

end