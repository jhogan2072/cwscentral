class AddCheckinToVanRoutes < ActiveRecord::Migration
  def change
    add_column :van_routes, :check_in_time, :string
  end
end
