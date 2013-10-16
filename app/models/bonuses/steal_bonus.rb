class Bonuses::StealBonus < Bonuses::Bonus

  def self.types
    [
        Bonuses::Trick,
        Bonuses::Cheat
    ]
  end

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