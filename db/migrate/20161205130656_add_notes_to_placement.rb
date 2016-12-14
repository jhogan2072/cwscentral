class AddNotesToPlacement < ActiveRecord::Migration
  def change
    add_column :placements, :notes, :string
  end
end
