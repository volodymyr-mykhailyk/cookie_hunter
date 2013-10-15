require 'bonuses/bonus'
FactoryGirl.define do
  factory :cookie_box, class: Bonuses::CookieBox  do
    stockpile
    saves 1000
  end

  factory :bread_plate, class: Bonuses::BreadPlate do
    stockpile
    saves 5000
  end

end