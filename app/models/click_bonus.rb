class ClickBonus < Bonus
  REGENERATION = 1
  PRICE = 100
  NAME = 'Click Bonus'

  validates_numericality_of :regeneration, equal_to: REGENERATION

end