class PlacementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_placement, only: [:edit, :update, :destroy]

  # GET /placements
  # GET /placements.json
  def index
    @placements = Placement.all
  end

  def attendance
    @todays_date = DateTime.now
  end

  def export_attendance
    grade_level = []
    @route_date = DateTime.strptime(params["route_date"], '%d-%b-%Y')
    params["selected_class"].each do |selection|
      if selection[1] != "0"
        grade_level << selection[1].to_i
      end
    end
    @grade_names = Placement.grade_names
    @attendance_export = []
    grade_level.each do |grade|
      attendance_list = Placement.attendance(params["route_date"], grade)
      if not attendance_list.first.nil?
        @attendance_export << attendance_list
      end
    end
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=attendance-' + params["route_date"] + '.xlsx'}
    end

=begin
    student first name, student last name, account name, route name, start date, check in time
    all_routes = VanRoute.where("route_date = ?", params[:route_date])
    @route_export = []
    all_routes.each do |route|
      route_info = VanRoute.joins(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                       .includes(:driver, :van, route_stops: {placement: [:student, [{contact_assignment: :contact}]]})
                       .where("van_routes.id = ?", route.id).order("route_stops.am_order")
      #TODO - the above join returns null for routes without route stops, resulting in an array with nils in it
      if not route_info.first.nil?
        @route_export << route_info.first
      end
    end
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=routes-' + params[:route_date] + '.xlsx'}
    end
=end
  end

  def organizations
    @organizations = Organization.all.order('name')
    respond_to do |format|

      format.html # organization_placements.html.erb
      format.json { render 'organizations.json.jbuilder': @organizations }

    end
  end

  def students
    @students = Student.all.order('last_name')
    respond_to do |format|

      format.html # students_placements.html.erb
      format.json { render 'students.json.jbuilder': @students }

    end
  end

  def contacts
    @contacts = Contact.active_contacts
    respond_to do |format|

      format.html # contacts_placements.html.erb
      format.json { render 'contacts.json.jbuilder': @contacts }

    end
  end

  # GET /placements/new
  def new
    @placement = Placement.new
  end

  def add
    student_id = params[:student_id]
    @student = Student.find(student_id)
    @placement = Placement.new
    @placement.student = @student
  end

  # GET /placements/1/edit
  def edit
    @student = @placement.student
  end

  # POST /placements
  # POST /placements.json
  def create
    @placement = Placement.new(placement_params)

    respond_to do |format|
      if @placement.save
        format.html { redirect_to students_placements_path("student_id" => params[:placement][:student_id]), notice: 'Placement was successfully created.' }
        format.json { head :no_content, status: :created }
      else
        format.html { render :new }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /placements/1
  # PATCH/PUT /placements/1.json
  def update
    respond_to do |format|
      if @placement.update(placement_params)
        format.html { redirect_to :back, notice: 'Placement was successfully updated.' }
        format.json { head :no_content, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /placements/1
  # DELETE /placements/1.json
  def destroy
    @placement.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, status: 303, notice: 'Placement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def org
    @placement = Placement.find(params[:id])
    #add the data to an array for JSON formatting purposes
    @placement_array = Array.new(1, @placement)
  end

  def export
    if params[:student_id]
      @placements = Placement.search(filtering_id=params[:student_id], query_type = 0)
    elsif params[:organization_id]
      @placements = Placement.search(filtering_id=params[:organization_id], query_type = 1)
    elsif params[:contact_id]
      @placements = Placement.search(filtering_id=params[:contact_id], query_type = 2)
    end
    respond_to do |format|
      format.html
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="placements.xlsx"'}
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placement
      @placement = Placement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      params.require(:placement).permit(:start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :student_id, :contact_assignment_id)
    end
end
