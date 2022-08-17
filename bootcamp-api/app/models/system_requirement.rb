class SystemRequirement < ApplicationRecord
	has_many :games
	validates :name, presence: true
	validates :memory, presence: true
	validates :storage, presence: true
	validates :operational_system, presence: true
	validates :video_board, presence: true
	validates :processor, presence: true

	include NameSearchable
	include Paginatable
end
