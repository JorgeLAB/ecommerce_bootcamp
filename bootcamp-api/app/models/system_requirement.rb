class SystemRequirement < ApplicationRecord
	has_many :games, dependent: :restrict_with_error
	validates :name, presence: true, uniqueness: {case_sensitive: false}
	validates :memory, presence: true
	validates :storage, presence: true
	validates :operational_system, presence: true
	validates :video_board, presence: true
	validates :processor, presence: true

	include NameSearchable
	include Paginatable
end
