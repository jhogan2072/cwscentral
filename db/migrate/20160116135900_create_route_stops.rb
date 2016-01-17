class CreateRouteStops < ActiveRecord::Migration
  def change
    create_table :route_stops do |t|
      t.string :stop_order
      t.references :van_route, index: true, foreign_key: true
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
