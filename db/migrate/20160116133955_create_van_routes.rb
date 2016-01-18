class CreateVanRoutes < ActiveRecord::Migration
  def change
    create_table :van_routes do |t|
      t.string :name
      t.date :route_date
      t.string :am_pm
      t.references :van, index: true, foreign_key: true
      t.references :driver, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
