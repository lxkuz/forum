FactoryBot.define do
  factory :authorize_transaction do
    merchant
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    amount { Faker::Number.decimal }
  end
end
