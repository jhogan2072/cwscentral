class AddCapacityToVans < ActiveRecord::Migration
  def change
    add_column :vans, :capacity, :integer
  end
end
