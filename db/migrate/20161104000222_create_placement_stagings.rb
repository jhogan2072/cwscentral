class CreatePlacementStagings < ActiveRecord::Migration
  def change
    create_table :placement_stagings do |t|
      t.string :student_first_name
      t.string :student_last_name
      t.string :student_middle_name
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :organization_name
      t.date :start_date
      t.date :end_date
      t.boolean :paid
      t.string :work_day
      t.string :student_gradelevel
      t.string :earliest_start
      t.string :latest_start
      t.string :ideal_start
      t.boolean :duplicate

      t.timestamps null: false
    end
  end
end
