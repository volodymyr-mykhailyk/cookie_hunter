# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stockpile do
    hunter

    cookies 1
    regeneration 0
    clicks 1
    saves 0
  end
end
