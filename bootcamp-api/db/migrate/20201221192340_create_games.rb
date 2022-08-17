class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :mode
      t.string :developer
      t.datetime :release_date
      t.references :system_requirement

      t.timestamps
    end
  end
end
