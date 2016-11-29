class PlacementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_placement, only: [:edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  include PlacementsHelper

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
    date_param = fix_sept(params["route_date"])

    @route_date = DateTime.strptime(date_param, '%d-%b-%Y')
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
      format.xlsx {
        if @attendance_export.length > 0
          response.headers['Content-Disposition'] = 'attachment; filename=attendance-' + params["route_date"] + '.xlsx'
        else
          redirect_to attendance_placements_url, notice: 'There are no current routes or students from the selected grade(s) on the routes defined for today.'
        end
      }
    end
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
    @organizations = Organization.current_organizations(@placement.start_date)
  end

  # POST /placements
  # POST /placements.json
  def create
    stripped_params = strip_number(placement_params)

    @placement = Placement.new(stripped_params)

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
      stripped_params = strip_number(placement_params)

      if @placement.update(stripped_params)
        format.html { redirect_to students_placements_path("student_id" => params[:placement][:student_id]), notice: 'Placement was successfully updated.' }
        format.json { head :no_content, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @placement.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /placements/1/edit_contact
  def edit_contact
    @placement = Placement.find(params[:id])
  end

  # PATCH/PUT /placements/1/update_contact
  def update_contact
    @placement = Placement.find(params[:id])
    respond_to do |format|
      if @placement.replace_supervisor(placement_params)
        format.html { redirect_to students_placements_path("student_id" => params[:placement][:student_id]), notice: 'Placement was successfully updated.' }
      else
        format.html { render :edit_contact}
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

  def import
    if request.method == "GET"
      #@placement_staging = PlacementStaging.all.order(:student_last_name, :student_first_name)
      @placement_staging = PlacementStaging.all.order("#{sort_column} #{sort_direction}")
    elsif request.method == "POST"
      PlacementStaging.import(params[:file_content])
      redirect_to import_placements_url, notice: "Placements imported to staging."
    end
  end

  def commit
    # Insert all the records in students_stagings into students
    placement_list = PlacementStaging.all
    placement_list.each do |staging_placement|
      if !staging_placement.duplicate
        student_id = Student.where(last_name: staging_placement.student_last_name)
                         .where(first_name: staging_placement.student_first_name)
                         .where(middle_name: staging_placement.student_middle_name).pluck(:id).first
        contact_id = Contact.where(last_name: staging_placement.contact_last_name)
                         .where(first_name: staging_placement.contact_first_name).pluck(:id).first
        organization_id = Organization.where(name: staging_placement.organization_name).pluck(:id).first
        contact_assignment_id = ContactAssignment.where(organization_id: organization_id)
                          .where(contact_id: contact_id)
                          .where("? between contact_assignments.effective_start_date and contact_assignments.effective_end_date", DateTime.now.to_date).pluck(:id).first
        if !student_id.nil? and student_id > 0 and !contact_assignment_id.nil? and contact_assignment_id > 0
          new_placement = Placement.new(
              student_id: student_id,
              contact_assignment_id: contact_assignment_id,
              start_date: staging_placement.start_date,
              end_date: staging_placement.end_date,
              paid: staging_placement.paid,
              work_day: staging_placement.work_day,
              student_gradelevel: staging_placement.student_gradelevel,
              earliest_start: staging_placement.earliest_start,
              latest_start: staging_placement.latest_start,
              ideal_start: staging_placement.ideal_start
          )

          new_placement.save
          placement_list.delete(staging_placement.id)
        end
      end
    end

    redirect_to import_placements_url, notice: "Placements imported!"
  end

  private
    def sortable_columns
      ["student_last_name", "student_first_name", "contact_first_name", "contact_last_name", "organization_name", "start_date",
      "end_date", "paid", "work_day", "student_gradelevel", "earliest_start", "latest_start", "ideal_start"]
    end

    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : "student_last_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_placement
      @placement = Placement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      params.require(:placement).permit(:start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :student_id, :contact_assignment_id)
    end
end
