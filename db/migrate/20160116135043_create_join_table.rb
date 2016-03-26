class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :route_stops, :students do |t|
       t.index [:route_stop_id, :student_id]
       t.index [:student_id, :route_stop_id]
    end
  end
end
