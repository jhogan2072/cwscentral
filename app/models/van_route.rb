class VanRoute < ActiveRecord::Base
  belongs_to :van
  belongs_to :driver
  has_many :route_stops, dependent: :destroy
  accepts_nested_attributes_for :route_stops, :allow_destroy => true
  validates_presence_of :name

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

  def self.fetch_routes(param_date)
    begin
      all_routes = where('route_date = ?', param_date).order('van_routes.name::int')
      # Have to start iterating the relation to figure out if there is a string in van_routes.name, which will
      # trigger the exception handler
      all_routes.first
    rescue ActiveRecord::StatementInvalid => e
      all_routes = VanRoute.where('route_date = ?', param_date)
    end

    routes_array = []
    all_routes.each do |route|
      route_info = VanRoute.joins(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                       .includes(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                       .where('van_routes.id = ?', route.id).order('route_stops.am_order')
      #TODO - the above join returns null for routes without route stops, resulting in an array with nils in it
      unless route_info.first.nil?
        routes_array << route_info.first
      end
    end
    return routes_array
  end

  def self.copy_route(copy_from_date, copy_to_date)
    routes = VanRoute.where(route_date: copy_from_date)
    routes.each do |route|
      route.clone_with_associations(copy_to_date)
    end
  end

  def self.prior_days(current_month)
    month_num = current_month.to_i
    where("EXTRACT(MONTH FROM route_date) between ? and ?", month_num, month_num + 1).select("route_date")
  end

end
