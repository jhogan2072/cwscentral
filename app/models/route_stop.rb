class RouteStop < ActiveRecord::Base
  belongs_to :van_route
  belongs_to :placement

  def self.filtered_stops
    joins(:van_route).where(van_routes: {route_date: Date.today })
    #joins(:van_route).where("van_routes.route_date between route_stops.start_date and route_stops.end_date" )
  end

  default_scope { order('stop_order') }
end
