class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :department
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :mobile
      t.string :office_phone
      t.string :fax
      t.integer :designations
      t.date :start_date
      t.string :sugarcrm_id
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
