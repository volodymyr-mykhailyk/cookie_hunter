class Bonuses::Trick < Bonuses::StealBonus
  STEALS = 1
  BASIC_PRICE = 1000
  NAME = 'Trick'
  DESCRIPTION = "Steal #{STEALS} cookies more"
end