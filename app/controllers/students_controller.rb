class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:edit, :update, :destroy]
  include PlacementsHelper

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
        format.html { redirect_to students_url, notice: 'Student was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to active_students_url, notice: 'Student was successfully updated.' }
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
      format.html { redirect_to active_students_url, notice: 'Student was successfully deleted.' }
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
  rescue ActiveRecord::UnknownAttributeError => e
    redirect_to import_students_url, notice: "The CSV contained unexpected fields. Please ensure the fields in the CSV match " +
    "those specified in the documentation for students."
  end

  def delete_staging
    student_list = StudentsStaging.all
    student_list.delete_all
    redirect_to import_students_url, notice: "Staged students deleted"
  end

  def commit
    # Insert all the records in students_stagings into students
    student_list = StudentsStaging.all
    student_list.each do |staging_student|
      if !staging_student.duplicate
        new_student = Student.new(
            last_name: staging_student.last_name,
            first_name: staging_student.first_name,
            middle_name: staging_student.middle_name,
            mobile_phone: staging_student.mobile_phone,
            classof: staging_student.classof,
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

  def export_feedback
    grade_level = []
    start_date_param = fix_sept(params["range_start_date"])
    end_date_param = fix_sept(params["range_end_date"])

    #@start_date = DateTime.strptime(start_date_param, '%d-%b-%Y')
    #@end_date = DateTime.strptime(end_date_param, '%d-%b-%Y')
    @students = Student.feedback_report(start_date_param, end_date_param)
    if @students.nil?
      @students = []
    end
    respond_to do |format|
      format.xlsx {
        if @students.length > 0
          response.headers['Content-Disposition'] = 'attachment; filename=feedback_report.xlsx'
        else
          redirect_to feedback_report_students_url, notice: 'There are no students with placements for selected date range.'
        end
      }
    end
  end

  def feedback_report
  end

  def graduate
    if request.method == "GET"
      @year = params[:year]
      @students = Student.where("classof = ?", @year).order("last_name")
    elsif request.method == "POST"
      year = params[:year]
      graduates = params[:graduates]
      unless graduates.nil?
        graduates.each do |student_id|
          graduate = Student.find(student_id)
          graduate.active = false
          graduate.save
        end
      end
      redirect_to graduate_students_path(:year => year), notice: "Selected students set to inactive status."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :middle_name, :mobile_phone, :classof, :leave_reason,
                                    :skills, :goals, :active, :year)
  end
end

