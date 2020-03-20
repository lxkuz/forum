FactoryBot.define do
  factory :authorize_transaction do
    merchant
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    amount { 10.99 }
  end

  trait :negative_amount do
    amount { -10.99 }
  end

  trait :approved_transaction do
    status { 'approved' }
  end
end
