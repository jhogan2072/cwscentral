class AddDearToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :dear, :string
  end
end
