class VanRoutesController < ApplicationController
  def index
    @van_route = VanRoute.find_by route_date: DateTime.now.to_date
    if @van_route.nil?
      @van_route = VanRoute.create(route_date: DateTime.now.to_date)
    end
  end
end
