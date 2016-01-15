class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :billing_address
      t.string :city
      t.string :state
      t.string :zip
      t.date :sponsor_since
      t.string :sugarcrm_id

      t.timestamps null: false
    end
  end
end
