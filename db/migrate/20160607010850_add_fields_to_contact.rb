class AddFieldsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :role, :string
    add_column :contacts, :date_started, :date
    add_column :contacts, :date_departed, :date
    add_column :contacts, :notes, :text
  end
end
