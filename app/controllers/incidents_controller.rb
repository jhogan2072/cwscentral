class IncidentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_incident, only: [:edit, :update, :destroy]

  def organizations
    @organizations = Organization.all.order('name')
    respond_to do |format|

      format.html # organization_placements.html.erb
      format.json { render 'organizations.json.jbuilder': @organizations }

    end
  end

  def students
    @students = Student.active_students.order('last_name')
    respond_to do |format|

      format.html # students_placements.html.erb
      format.json { render 'students.json.jbuilder': @students }

    end
  end

  def contacts
    @contacts = Contact.all.order(:last_name, :first_name)
    respond_to do |format|

      format.html # contacts_placements.html.erb
      format.json { render 'contacts.json.jbuilder': @contacts }

    end
  end

  # GET /incidents/new
  def new
    student_id = params[:student_id]
    if student_id.nil?
      flash[:notice] = "You tried to access an invalid URL."
      redirect_to students_incidents_url
    else
      @student = Student.find(student_id)
      @incident = Incident.new
      @incident.student = @student
    end
  end

  # GET /incidents/1/edit
  def edit
    @student = Student.find(@incident.student_id)
  end

  # POST /incidents
  # POST /incidents.json
  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to students_incidents_url, notice: 'Feedback was successfully created.' }
      else
        student_id = incident_params["student_id"]
        @student = Student.find(student_id)
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /incidents/1
  # PATCH/PUT /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to students_incidents_url("student_id" => params[:incident][:student_id]), notice: 'Feedback was successfully updated.' }
        #format.html { redirect_to students_incidents_url, format: :html, notice: 'Feedback was successfully updated.' }
      else
        @student = Student.find(@incident.student_id)
        format.html { render :edit }
      end
    end
  end

  # DELETE /incidents/1
  # DELETE /incidents/1.json
  def destroy
    @incident.destroy
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    if params.has_key?(:student_id) && is_integer?(params[:student_id])
      @incidents = Incident.search(params[:student_id], 0)
    elsif params.has_key?(:organization_id) && is_integer?(params[:organization_id])
      @incidents = Incident.search(params[:organization_id], 1)
    elsif params.has_key?(:contact_id) && is_integer?(params[:contact_id])
      @incidents = Incident.search(params[:contact_id], 2)
    end

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="feedback.xlsx"'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def incident_params
      params.require(:incident).permit(:incident_date, :incident_category_id, :description, :student_id, :contact_assignment_id)
    end
end
