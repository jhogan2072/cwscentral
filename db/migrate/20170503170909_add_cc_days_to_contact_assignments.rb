class AddCcDaysToContactAssignments < ActiveRecord::Migration
  def change
    add_column :contact_assignments, :cc_days, :integer
  end
end
