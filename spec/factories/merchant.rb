FactoryBot.define do
  factory :merchant, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.first_name }
    role { :merchant }
    activity { true }
  end

  trait :inactive_merchant do
    activity { false }
  end

  factory :with_money do
    total_transaction_sum { 10.99 }
  end
end
