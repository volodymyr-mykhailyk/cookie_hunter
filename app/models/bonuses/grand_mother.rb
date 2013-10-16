class Bonuses::GrandMother < Bonuses::RegenerationBonus

  REGENERATION = 5
  BASIC_PRICE = 300
  NAME = 'Grand Mother'
  DESCRIPTION = "Generate #{REGENERATION} cookies"

  validates_numericality_of :regeneration, equal_to: REGENERATION

end