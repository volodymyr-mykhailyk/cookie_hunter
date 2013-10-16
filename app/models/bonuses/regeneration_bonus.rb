class Bonuses::RegenerationBonus < Bonuses::Bonus

  def self.types
    [
        Bonuses::GrandMother,
        Bonuses::Stove
    ]
  end

  validates_presence_of :regeneration

  delegate :recalculate_regeneration, to: :stockpile
  after_save :recalculate_regeneration

  before_validation :set_regeneration

  def set_regeneration
    self.regeneration = self.class::REGENERATION
  end

  def value
    self.class::REGENERATION
  end

end