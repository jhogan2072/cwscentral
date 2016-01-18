class VanRoute < ActiveRecord::Base
  belongs_to :van
  belongs_to :driver
  has_many :route_stops
  has_and_belongs_to_many :students
  accepts_nested_attributes_for :route_stops, :allow_destroy => true
end
