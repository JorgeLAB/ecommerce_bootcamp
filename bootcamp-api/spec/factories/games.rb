FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_date { Faker::Date.between(from: '2014-09-23', to: '2014-09-25') }
    developer { Faker::Company.name }
    system_requirement
  end
end
