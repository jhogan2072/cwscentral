class VanRoute < ActiveRecord::Base
  belongs_to :van
  belongs_to :driver
  has_many :route_stops, dependent: :destroy
  accepts_nested_attributes_for :route_stops, :allow_destroy => true
  validates_presence_of :name

  default_scope { order('van_routes.name') }

  def clone_with_associations(copy_to_date)
    new_van_route = self.dup
    new_van_route.route_date = copy_to_date

    self.route_stops.each do |route_stop|
      new_route_stop = route_stop.dup
      new_route_stop.save
      new_van_route.route_stops << new_route_stop
    end

    new_van_route.save
  end

  def self.copy_route(copy_from_date, copy_to_date)
    routes = VanRoute.where(route_date: copy_from_date)
    routes.each do |route|
      route.clone_with_associations(copy_to_date)
    end
  end

end
