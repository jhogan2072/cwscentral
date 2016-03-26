class VanRoutesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_van_route, only: [:show, :edit, :update, :destroy]
respond_to :html, :json

  # GET /van_routes
  # GET /van_routes.json
  def index
    if params[:route_date]
      @todays_date = params[:route_date]
    else
      @todays_date = DateTime.now
    end
    @previous_school_day = 1.business_days.before(@todays_date.to_date)

    respond_with VanRoute.joins(:driver).includes(:driver, :van).where(:route_date => @todays_date).to_json(:include => [:driver, :van])
  end

  # GET /van_routes/1
  # GET /van_routes/1.json
  def show
  end

  # GET /van_routes/new
  def new
    @van_route = VanRoute.new(route_date: DateTime.now, am_pm: 'AM', van_id: Van.first.id, driver_id: Driver.first.id)
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
  #      format.html { redirect_to(van_routes_url, route_date: @van_route.route_date, format: :html, notice: 'Van route was successfully created.') }
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
    @van_route = VanRoute.find(params[:id])
    @route_export = VanRoute.joins(:driver, :van, :students).includes(:driver, :van, :students).where("van_routes.id = ?", @van_route.id)
    respond_to do |format|
      format.csv { send_data @route_export.to_csv }
      format.xls { send_data @route_export.to_csv(col_sep: "\t") }
    end
  end

  def org
    @van_route = VanRoute.find(params[:id])
    #add the data to an array for JSON formatting purposes
    @assignment_array = Array.new(1, @van_route)
  end

  def copy
    copy_from = params[:copy_from]
    copy_to = params[:copy_to]
    new_routes = VanRoute.copy_route(copy_from, copy_to)

    respond_with VanRoute.joins(:driver).includes(:driver, :van).where(:route_date => copy_to).to_json(:include => [:driver, :van])
  end

private
# Use callbacks to share common setup or constraints between actions.
def set_van_route
  @van_route = VanRoute.find(params[:id])
end

# Never trust parameters from the scary internet, only allow the white list through.
def van_route_params
  params.require(:van_route).permit(:id, :name, :route_date, :am_pm, :van_id, :driver_id, route_stops_attributes: [:id, :stop_order, :organization_id, {:student_ids => []}])
end
end
