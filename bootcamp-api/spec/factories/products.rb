FactoryBot.define do
  factory :product do
    sequence(:name) { |i| "Product #{i}"}
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }

    image { FactoryHelpers.upload_file(Rails.root.join("spec/support/images/product_image.png"), 'image/png', true) }
    status { :available }
    featured { true }

    after :build do |product|
    	product.productable ||= create(:game)
  	end
  end
end
