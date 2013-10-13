class ClickBonus < Bonus
  REGENERATION = 1
  PRICE = 10
  NAME = 'Click Bonus'

  validates_numericality_of :regeneration, equal_to: REGENERATION
  before_validation :set_regeneration

  def set_regeneration
    self.regeneration = self.class::REGENERATION
  end
end