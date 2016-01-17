class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :van_routes, :students do |t|
      # t.index [:van_route_id, :student_id]
      # t.index [:student_id, :van_route_id]
    end
  end
end
