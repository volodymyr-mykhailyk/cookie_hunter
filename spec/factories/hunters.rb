# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hunter do
    ignore { cookies 0 }
    sequence(:email) { |n| "test_hunter_#{n}@test.com"}
    password '12345678'
    password_confirmation '12345678'

    after(:create) do |hunter, evaluator|
      hunter.stockpile.update_column(:cookies, evaluator.cookies)
    end
  end
end
