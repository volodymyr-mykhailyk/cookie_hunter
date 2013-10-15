class Bonuses::SaveBonus < Bonuses::Bonus
  TYPES = [
      Bonuses::CookieBox,
      Bonuses::BreadPlate
  ]

  validates_presence_of :saves

  delegate :recalculate_saves, to: :stockpile
  after_save :recalculate_saves

  before_validation :set_saves

  def set_saves
    self.saves = self.class::SAVES
  end

  def value
    self.class::SAVES
  end

end