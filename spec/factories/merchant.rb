FactoryBot.define do
  factory :merchant, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.first_name }
    role { :merchant }
    active { true }
  end

  trait :inactive_merchant do
    active { false }
  end

  trait :with_money do
    total_transaction_sum { 10.99 }
  end
end
