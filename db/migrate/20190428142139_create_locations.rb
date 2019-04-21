class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.references :world, foreign_key: true
      t.string :name, null: false
      t.text :description
      # PostGIS geography location
      t.st_point :lonlat, geographic: true

      t.timestamps
    end

    add_index :locations, :lonlat, using: :gist
  end
end
