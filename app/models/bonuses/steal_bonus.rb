class Bonuses::StealBonus < Bonuses::Bonus
  TYPES = [
      Bonuses::Trick,
      Bonuses::Cheat
  ]

  validates_presence_of :steals

  delegate :recalculate_steals, to: :stockpile
  after_save :recalculate_steals

  before_validation :set_steals

  def set_steals
    self.steals = self.class::STEALS
  end

  def value
    self.class::STEALS
  end
end