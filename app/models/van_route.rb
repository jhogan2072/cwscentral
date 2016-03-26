class VanRoute < ActiveRecord::Base
  belongs_to :van
  belongs_to :driver
  has_many :route_stops, dependent: :destroy
  accepts_nested_attributes_for :route_stops, :allow_destroy => true
  default_scope { order('van_routes.name') }

  def clone_with_associations(copy_to_date)
    new_van_route = self.dup
    new_van_route.route_date = copy_to_date

    self.route_stops.each do |route_stop|
      new_route_stop = route_stop.clone
      new_route_stop.students = route_stop.students
      new_route_stop.save
      new_van_route.route_stops << new_route_stop
    end

    new_van_route.save
  end

  def self.copy_route(copy_from_date, copy_to_date)
    routes = VanRoute.where(route_date: copy_from_date)
    routes.each do |route|
      route.clone_with_associations(copy_to_date)
#      VanRoute.create(name: route.name, am_pm: route.am_pm, route_date: copy_to_date, van_id: route.van_id, driver_id: route.driver_id)
    end
  end

end
