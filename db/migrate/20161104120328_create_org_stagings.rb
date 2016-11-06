class CreateOrgStagings < ActiveRecord::Migration
  def change
    create_table :org_stagings do |t|
      t.string :name
      t.string :billing_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :sponsor_since
      t.boolean :duplicate

      t.timestamps null: false
    end
  end
end
