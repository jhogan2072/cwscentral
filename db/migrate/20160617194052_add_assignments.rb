class AddAssignments < ActiveRecord::Migration
  def change
    create_table :contact_assignments do |t|
      t.datetime :effective_start_date
      t.datetime :effective_end_date
      t.integer :organization_id
      t.integer :contact_id
      t.string   :title
      t.string   :department
      t.string   :address
      t.string   :city
      t.string   :state
      t.string   :zip
      t.string   :business_email
      t.string   :office_phone
      t.string   :fax
      t.string   :role
      t.text     :notes
      t.references :organizations, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true
      t.timestamps null: false
    end

    remove_column :contacts, :organization_id, :integer
    remove_column :contacts, :date_started, :date
    remove_column :contacts, :date_departed, :date
    remove_column :contacts, :title, :string
    remove_column :contacts, :department, :string
    remove_column :contacts, :address, :string
    remove_column :contacts, :city, :string
    remove_column :contacts, :state, :string
    remove_column :contacts, :zip, :string
    remove_column :contacts, :office_phone, :string
    remove_column :contacts, :fax, :string
    remove_column :contacts, :role, :string
    remove_column :contacts, :notes, :text

  end
end
