class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to students_url, notice: 'Student was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @student = Student.find(params[:id])
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=' + @student.last_name + '.xlsx'}
    end
  end

  def incidents
    #retrieve a students incident history
    @incidents = Incident.search(filtering_id=params[:id], query_type=0)
    if @incidents.length == 0
      render json: :no_content, status: 404
    end
  end

  def placements
    #retrieve a students work history
    @placements = Placement.search(filtering_id=params[:id], query_type=0)
    if @placements.length == 0
      render json: :no_content, status: 404
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :middle_name, :powerschool_id)
  end
end

