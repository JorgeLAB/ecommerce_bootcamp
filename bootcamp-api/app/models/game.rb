class Game < ApplicationRecord
  belongs_to :system_requirement
  belongs_to :license
  has_one :product, as: :productable

  validates :mode, presence: true
  validates :release_date, presence: true
  validates :developer, presence: true

  enum mode: {pvp: 1, pve: 2, both: 3} 
end
