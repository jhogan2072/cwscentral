class RouteStop < ActiveRecord::Base
  belongs_to :van_route
  belongs_to :organization
end
