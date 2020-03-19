FactoryBot.define do
  factory :admin, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.first_name }
    role { :admin }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
