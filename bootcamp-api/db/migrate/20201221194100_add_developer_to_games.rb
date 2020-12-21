class AddDeveloperToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :developer, :string
  end
end
