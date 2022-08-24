class AddLicenseIdToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :license, foreign_key: true
  end
end
