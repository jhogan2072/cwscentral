class FixColumns < ActiveRecord::Migration
  def change
    remove_column :contact_assignments, :organizations_id, :integer
    rename_column :contacts, :email, :personal_email
    rename_column :contacts, :mobile, :personal_mobile
  end
end
