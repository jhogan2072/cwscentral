class CreateVans < ActiveRecord::Migration
  def change
    create_table :vans do |t|
      t.string :name
      t.string :plate_number
      t.string :vin
      t.string :make
      t.string :model_year
      t.string :last_oil_change

      t.timestamps null: false
    end
  end
end
