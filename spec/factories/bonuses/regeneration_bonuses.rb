require 'bonuses/bonus'
FactoryGirl.define do
  factory :grand_mother, class: Bonuses::GrandMother  do
    stockpile
    regeneration 5
  end

  factory :stove, class: Bonuses::Stove do
    stockpile
    regeneration 10
  end
end