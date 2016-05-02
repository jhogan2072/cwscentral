class AddMobilePhoneToStudents < ActiveRecord::Migration
  def change
    add_column :students, :mobile_phone, :string
  end
end
