class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    if request.format == "json"
      @students = Student.all.order(:last_name)
    end
  end

  def active
    if request.format == "json"
      @students = Student.active_students.order(:last_name)
    end
    render :index
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

  def export_all
    @students = Student.all
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename=all_students.xlsx'}
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

  def import
    if request.method == "GET"
      @students_staging = StudentsStaging.all.order(:last_name, :first_name)
    elsif request.method == "POST"
      StudentsStaging.import(params[:file_content])
      redirect_to import_students_url, notice: "Students imported to staging."
    end
  end

  def commit
    # Insert all the records in students_stagings into students
    student_list = StudentsStaging.all
    student_list.each do |staging_student|
      #mystudent = Student.where(last_name: staging_student.last_name).where(first_name: staging_student.first_name).first
      #mystudent.update_attributes(classof: staging_student.classof)
      if !staging_student.duplicate
        new_student = Student.new(
            last_name: staging_student.last_name,
            first_name: staging_student.first_name,
            middle_name: staging_student.middle_name,
            mobile_phone: staging_student.mobile_phone,
            skills: staging_student.skills,
            goals: staging_student.goals,
            active: staging_student.active)

        new_student.save
      end
    end
    ensure
      student_list.delete_all

    redirect_to import_students_url, notice: "Students imported!"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :middle_name, :mobile_phone, :classof, :leave_reason,
                                    :skills, :goals, :active)
  end
end

