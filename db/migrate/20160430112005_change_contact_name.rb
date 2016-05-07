class ChangeContactName < ActiveRecord::Migration
  def change
    rename_column :contacts, :name, :first_name
    add_column :contacts, :last_name, :string
    add_column :contacts, :salutation, :string
  end
end
