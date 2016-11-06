class CreateContactStagings < ActiveRecord::Migration
  def change
    create_table :contact_stagings do |t|
      t.string :first_name
      t.string :last_name
      t.string :salutation
      t.string :dear
      t.string :personal_mobile
      t.string :start_date
      t.string :organization_name
      t.string :title
      t.string :department
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :business_email
      t.string :office_phone
      t.string :fax
      t.string :role
      t.boolean :duplicate

      t.timestamps null: false
    end
  end
end
