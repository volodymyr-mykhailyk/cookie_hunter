require 'bonus'
FactoryGirl.define do
  factory :click_bonus do
    stockpile
    regeneration 1
  end

  factory :grand_mother_bonus do
    stockpile
    regeneration 5
  end
end
