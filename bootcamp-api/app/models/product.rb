class Product < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :productable, polymorphic: true
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_one_attached :image # or has_many_attached if you can more than 1 image to the product

  with_options presence: true do
    validates :status, :description, :image
    validates :name, uniqueness: { case_sensitive: false }
    validates :price, numericality: { greater_than: 0}
  end

  validates :featured, presence: true, if: -> { featured.nil? }

  enum status: { available: 1, unavailable: 2 }  

  include LikeSearchable
  include Paginatable

  def to_home_builder
    Jbuilder.new do |product|
      product.(self, :id, :name, :description)
      product.price price.to_f
      product.image_url rails_blob_path(image, disposition: "attachment", only_path: true)
    end
  end
end
