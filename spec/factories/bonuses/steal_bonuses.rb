require 'bonuses/bonus'
FactoryGirl.define do
  factory :trick, class: Bonuses::Trick  do
    stockpile
    steals 1
  end

  factory :cheat, class: Bonuses::Cheat do
    stockpile
    steals 5
  end

end