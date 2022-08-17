class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_one_attached :image # or has_many_attached if you can more than 1 image to the product

  with_options presence: true do
    validates :status, :description, :image
    validates :name, uniqueness: { case_sensitive: false }
    validates :price, numericality: { greater_than: 0}
  end

  enum status: { available: 1, unavailable: 2 }  

  include NameSearchable
  include Paginatable
end
