class AddAmpmNotesToRouteStops < ActiveRecord::Migration
  def change
    add_column :route_stops, :am_notes, :string
    add_column :route_stops, :pm_notes, :string
  end
end
