class License < ApplicationRecord
  belongs_to :user
  has_many :games

  validates :key, presence: true, uniqueness: {case_sensitive: true}

  include Paginatable
end
