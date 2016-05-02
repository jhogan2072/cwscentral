class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.datetime :incident_date
      t.text :description
      t.references :student, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
