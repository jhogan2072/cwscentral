class PlacementsController < ApplicationController
  before_action :set_placement, only: [:show, :edit, :update, :destroy]

  # GET /placements
  # GET /placements.json
  def index
    @placements = Placement.all
  end

  # GET /placements/1
  # GET /placements/1.json
  def show
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
        format.html { redirect_to students_path, notice: 'Placement was successfully created.' }
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
      @placements = Placement.search(student_id=params[:student_id])
    elsif params[:organization_id]
      @placements = Placement.search(organization_id=params[:organization_id])
    end
    respond_to do |format|
      format.html
      format.csv { send_data @placements.to_csv }
      format.xls # { send_data @placements.to_csv(col_sep: "\t") }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_placement
      @placement = Placement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      params.require(:placement).permit(:start_date, :end_date, :paid, :work_day, :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :student_id, :contact_id)
    end
end
