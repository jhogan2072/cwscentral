class RouteStop < ActiveRecord::Base
  belongs_to :van_route
  belongs_to :organization
  has_and_belongs_to_many :students

  default_scope { order('stop_order') }
end
