class PlacementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_placement, only: [:edit, :update, :destroy]

  # GET /placements
  # GET /placements.json
  def index
    @placements = Placement.all
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
    @contacts = Contact.all.order('last_name')
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
        format.html { redirect_to students_path, notice: 'Placement was successfully created.' }
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
      format.csv { send_data @placements.to_csv }
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
