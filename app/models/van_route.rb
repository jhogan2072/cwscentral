class VanRoute < ActiveRecord::Base
  belongs_to :van
  belongs_to :driver
  has_many :route_stops, dependent: :destroy
  has_and_belongs_to_many :students
  accepts_nested_attributes_for :route_stops, :allow_destroy => true

  def self.copy_route(copy_from_date, copy_to_date)
    routes = VanRoute.where(route_date: copy_from_date)
    routes.each do |route|
      VanRoute.create(name: route.name, am_pm: route.am_pm, route_date: copy_to_date, van_id: route.van_id, driver_id: route.driver_id)
    end
  end
end
