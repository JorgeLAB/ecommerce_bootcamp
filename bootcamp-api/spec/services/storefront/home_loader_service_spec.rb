require 'rails_helper'

describe Storefront::HomeLoaderService do
  context 'when #call' do
    let!(:unavaible_products) do
      products= []
      5.times do
        game = create(:game, release_date: 2.days.ago)
        products << create(:product, productable: game, price: 5.00, status: :unavailable)
      end
      products
    end

    context 'on featured products' do
      let!(:no_featured_products) { create_list(:product, 5, featured: false) }
      let!(:featured_products) { create_list(:product, 5) }

      it 'return 4 records' do
        service = described_class.new
        service.call
        expect(service.featured.count).to eq 4
      end

      it 'returns random, featured avaiable products' do
        service = described_class.new
        service.call
        expect(service.featured).to satisfy do |expected_products|
          expected_products & featured_products == expected_products
        end
      end

      it 'does not return unavailable or non-featured products' do
        service = described_class.new
        service.call
        expect(service.featured).to_not include(featured_products, no_featured_products)
      end
    end

    context 'on recently released products' do
      let!(:non_last_release_products) do
        products = []
        5.times do
          game = create(:game, release_date: 8.day.ago)
          products << create(:product, productable: game)
        end
      end

      let!(:last_release_products) do
        products = []
        5.times do
          game = create(:game, release_date: 2.day.ago)
          products << create(:product, productable: game)
        end
        products
      end

      it 'returns 4 records' do
        service = described_class.new
        service.call
        expect(service.last_releases.count).to eq 4
      end

      it 'returns random featured available products' do
        service = described_class.new
        service.call
      end

      it 'does not return unavailable or non-featured products' do
        service = described_class.new
        service.call
        expect(service.featured).to_not include(last_release_products, non_last_release_products)
      end
    end

    context 'on cheapest products' do
      let!(:non_cheapest) { create_list(:product, 5, price: 110.00) }
      let!(:cheapest_products) { create_list(:product, 5, price: 5.00) }

      it 'return 4 records' do
        service = described_class.new
        service.call
        expect(service.cheapest.count).to eq 4
      end

      it 'returns cheapest avaiable products' do
        service = described_class.new
        service.call
        expect(service.cheapest).to satisfy do |expected_products|
            expected_products & cheapest_products == expected_products
        end
      end

      it 'returns non-cheapest or unavailable products' do
        service = described_class.new
        service.call
        expect(service.cheapest).to_not include(unavaible_products, non_cheapest)
      end
    end
  end
end
