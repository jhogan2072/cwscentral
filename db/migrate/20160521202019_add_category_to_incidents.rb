class AddCategoryToIncidents < ActiveRecord::Migration
  def change
    add_reference :incidents, :incident_category, index: true, foreign_key: true
  end
end
