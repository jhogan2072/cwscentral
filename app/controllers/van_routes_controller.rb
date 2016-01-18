class VanRoutesController < ApplicationController
  def index
    @van_route = VanRoute.find_by route_date: DateTime.now.to_date
    if @van_route.nil?
      @van_route = VanRoute.new(route_date: DateTime.now.utc, am_pm: "AM", van_id: Van.first.id, driver_id: Driver.first.id)
      @van_route.route_stops.build
    else
      @van_route.route_date = Time.zone.parse(@van_route.route_date).utc
    end
  end
end
