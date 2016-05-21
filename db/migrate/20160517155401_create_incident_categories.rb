class CreateIncidentCategories < ActiveRecord::Migration
  def change
    create_table :incident_categories do |t|
      t.string :category

      t.timestamps null: false
    end
  end
end
