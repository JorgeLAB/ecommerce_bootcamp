FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Intemediate #{n}" }
    operational_system { Faker::Computer.os }
    storage { "500gb" }
    processor { "AMD" }
    memory { "12gb" }
    video_board { "GForce X" }
  end
end
