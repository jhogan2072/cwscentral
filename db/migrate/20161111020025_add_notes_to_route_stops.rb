class AddNotesToRouteStops < ActiveRecord::Migration
  def change
    add_column :route_stops, :notes, :string
  end
end
