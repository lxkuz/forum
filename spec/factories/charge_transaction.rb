FactoryBot.define do
  factory :charge_transaction do
    merchant { create(:merchant, :with_money) }
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    amount { 10.99 }
    type { 'ChargeTransaction' }
    status { 'approved' }
  end

  trait :not_approved_transaction do
    status { 'initial' }
  end
end
