class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :paid
      t.string :work_day
      t.integer :student_gradelevel
      t.string :earliest_start
      t.string :latest_start
      t.string :ideal_start
      t.references :student, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
