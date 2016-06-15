class AddSkillsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :skills, :string
    add_column :students, :goals, :string
  end
end
