class AddOutOfServiceToVans < ActiveRecord::Migration
  def change
    add_column :vans, :out_of_service, :boolean, default: false
    add_column :vans, :expected_return_date, :date
  end
end
