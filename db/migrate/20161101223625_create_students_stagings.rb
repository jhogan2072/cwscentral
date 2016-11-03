class CreateStudentsStagings < ActiveRecord::Migration
  def change
    create_table :students_stagings do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :mobile_phone
      t.string :skills
      t.string :goals
      t.boolean :active
      t.boolean :duplicate
      t.string :powerschool_id

      t.timestamps null: false
    end
  end
end
