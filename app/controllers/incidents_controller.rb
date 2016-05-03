class IncidentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_incident, only: [:show, :edit, :update, :destroy]

  # GET /incidents
  # GET /incidents.json
  def index
    @incidents = Incident.all
  end

  def organizations
    @organizations = Organization.all.order('name')
    respond_to do |format|

      format.html # organization_placements.html.erb
      format.json { render 'organizations.json.jbuilder': @organizations }

    end
  end

  def add
    student_id = params[:student_id]
    @student = Student.find(student_id)
    @incident = Incident.new
    @incident.student = @student
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
  # GET /incidents/1
  # GET /incidents/1.json
  def show
  end

  # GET /incidents/new
  def new
    @incident = Incident.new
  end

  # GET /incidents/1/edit
  def edit
  end

  # POST /incidents
  # POST /incidents.json
  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: 'Incident was successfully created.' }
        format.json { render :show, status: :created, location: @incident }
      else
        format.html { render :new }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incidents/1
  # PATCH/PUT /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to @incident, notice: 'Incident was successfully updated.' }
        format.json { render :show, status: :ok, location: @incident }
      else
        format.html { render :edit }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1
  # DELETE /incidents/1.json
  def destroy
    @incident.destroy
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incident was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def incident_params
      params.require(:incident).permit(:incident_date, :description, :student_id, :contact_id)
    end
end
