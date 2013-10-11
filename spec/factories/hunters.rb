# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hunter do
    sequence(:email) { |n| "test_hunter_#{n}@test.com"}
    password '12345678'
    password_confirmation '12345678'
  end
end
