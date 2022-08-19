FactoryBot.define do
  factory :license do
    key { Faker::Alphanumeric.alpha(number: 10) }
    user_id { create(:user).id }
  end
end
