class Game < ApplicationRecord
  belongs_to :system_requirement
  belongs_to :license, optional: true
  has_one :product, as: :productable

  validates :mode, presence: true
  validates :release_date, presence: true
  validates :developer, presence: true

  enum mode: {pvp: 1, pve: 2, both: 3}

  include LikeSearchable
end
