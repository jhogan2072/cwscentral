class RouteStop < ActiveRecord::Base
  belongs_to :van_route
  belongs_to :placement

  default_scope { order('stop_order') }
end
