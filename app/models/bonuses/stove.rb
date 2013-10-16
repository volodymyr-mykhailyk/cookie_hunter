class Bonuses::Stove < Bonuses::RegenerationBonus

  REGENERATION = 10
  BASIC_PRICE = 500
  NAME = 'Stove'
  DESCRIPTION = "Generate #{REGENERATION} cookies"

  validates_numericality_of :regeneration, equal_to: REGENERATION

end