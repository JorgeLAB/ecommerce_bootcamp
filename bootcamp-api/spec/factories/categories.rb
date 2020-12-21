FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "MyString #{n}" }
  end
end
