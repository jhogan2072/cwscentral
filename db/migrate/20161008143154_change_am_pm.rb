class ChangeAmPm < ActiveRecord::Migration
  def change
    remove_column :van_routes, :am_pm
    rename_column :route_stops, :stop_order, :am_order
    add_column :route_stops, :pm_order, :string
  end
end
