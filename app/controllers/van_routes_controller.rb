class VanRoutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_van_route, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json
  autocomplete :placement, :org_contact_student

  def get_autocomplete_items(parameters)
    term = params[:term]
    placements = Placement.joins(contact_assignment: [:organization, :contact])
                     .includes(contact_assignment: [:organization, :contact]).includes(:student)
                     .where("placements.start_date <= ? and placements.end_date >= ? and organizations.name ILIKE ?",
                            params[:route_date], params[:route_date], "#{term}%")
    placements.map { |placement| {:id => placement.id, :label => placement.org_contact_student, :value => placement.org_contact_student} }
  end

  def json_for_autocomplete(items, method, extra_data=[])
    items
  end

  # GET /van_routes
  # GET /van_routes.json
  def index
    if params[:route_date]
      @todays_date = Time.zone.parse(params[:route_date]).to_date
    else
      @todays_date = DateTime.now
    end
    @previous_school_day = 1.business_days.before(@todays_date.to_date)
    begin
      query_result = VanRoute.joins(:driver).includes(:driver, :van).where(:route_date => @todays_date).order("van_routes.name::int").to_json(:include => [:driver, :van])
    rescue ActiveRecord::StatementInvalid => e
      query_result = VanRoute.joins(:driver).includes(:driver, :van).where(:route_date => @todays_date).to_json(:include => [:driver, :van])
    end

    respond_with query_result
  end

  # GET /van_routes/1
  # GET /van_routes/1.json
  def show
  end

  # GET /van_routes/new
  def new
    @van_route = VanRoute.new(route_date: DateTime.now, van_id: Van.first.id, driver_id: Driver.first.id)
    if params[:route_date]
      @van_route.route_date = params[:route_date]
    end
    @van_route.route_stops.build
  end

  # GET /van_routes/1/edit
  def edit
    @van_route.route_date = Time.zone.parse(@van_route.route_date.beginning_of_day().to_s)
  end

  # POST /van_routes
  # POST /van_routes.json
  def create
    @van_route = VanRoute.new(van_route_params)

    respond_to do |format|
      if @van_route.save
        format.html { redirect_to :controller=>'van_routes',:action=>'index',route_date: @van_route.route_date, format: :html, notice: 'Van route was successfully created.' }
        format.json { render :show, status: :created, location: @van_route }
      else
        format.html { render :new }
        format.json { render json: @van_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /van_routes/1
  # PATCH/PUT /van_routes/1.json
  def update
    respond_to do |format|
      if @van_route.update(van_route_params)
        format.html { redirect_to edit_van_route_url, notice: 'Van route was successfully updated.' }
        format.json { render :show, status: :ok, location: @van_route }
      else
        format.html { render :edit }
        format.json { render json: @van_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /van_routes/1
  # DELETE /van_routes/1.json
  def destroy
    @van_route.destroy
    respond_to do |format|
      format.html { redirect_to van_routes_url, notice: 'Van route was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @route_export = VanRoute.joins(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                        .includes(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                        .where("van_routes.id = ?", params[:id]).order("route_stops.am_order")
                        .order("contact_assignments.organization_id").first
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=' + @route_export.name + '.xlsx'}
    end
  end

  def export_all
    @route_export = VanRoute.fetch_routes(params[:route_date])
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=routes-' + params[:route_date] + '.xlsx'}
    end
  end

  def org
    @van_route = VanRoute.find(params[:id])
    #add the data to an array for JSON formatting purposes
    @placement_array = Array.new(1, @van_route)
  end

  def copy
    copy_from = params[:copy_from]
    copy_to = params[:copy_to]
    new_routes = VanRoute.copy_route(copy_from, copy_to)

    respond_with VanRoute.joins(:driver).includes(:driver, :van).where(:route_date => copy_to).to_json(:include => [:driver, :van])
  end

  def prior_days
    current_month = params[:current_month]
    respond_with VanRoute.prior_days(current_month)
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_van_route
    @van_route = VanRoute.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def van_route_params
    params.require(:van_route).permit(:id, :name, :route_date, :van_id, :driver_id, :check_in_time,
                                      route_stops_attributes: [:id, :am_order, :pm_order, :placement_id, :am_notes, :pm_notes, :notes, :_destroy])
  end
end
