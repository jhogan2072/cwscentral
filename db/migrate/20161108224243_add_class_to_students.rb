class AddClassToStudents < ActiveRecord::Migration
  def change
    add_column :students, :classof, :integer
    add_column :students, :leave_reason, :string
    add_column :students_stagings, :classof, :integer
  end
end
