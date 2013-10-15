require 'bonuses/bonus'
FactoryGirl.define do
  factory :plus_click, class: Bonuses::PlusClick  do
    stockpile
    clicks 1
  end

  factory :double_click, class: Bonuses::DoubleClick do
    stockpile
  end

end