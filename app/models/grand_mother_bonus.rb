class GrandMotherBonus < Bonus
  REGENERATION = 5
  PRICE = 300
  NAME = 'GrandMother Bonus'

  validates_numericality_of :regeneration, equal_to: REGENERATION

end