class ContactAssignmentsController < ApplicationController
  before_action :set_contact_assignment, only: [:show, :update]

  # GET /contact_assignments/1
  # GET /contact_assignments/1.json
  def show
  end

  def index
    organization_id = params[:organization_id]
    start_date = params[:start_date]
    @contact_assignments = ContactAssignment.for_org_and_start_date(organization_id, start_date)
  end

  def get_by_org
    organization_id = params[:id]
    @placement = ContactAssignment.for_organization(organization_id)
    #add the data to an array for JSON formatting purposes
    @placement_array = Array.new(1, @placement)
  end

  # PATCH/PUT /contact_assignments/1
  # PATCH/PUT /contact_assignments/1.json
  def update
    respond_to do |format|
      if @contact_assignment.update(contact_assignment_params)
        format.html { redirect_to contacts_url, notice: 'Contact assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_assignment }
      else
        format.html { render :edit }
        format.json { render json: @contact_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def reopen
    @contact_assignment = Contact.find(params[:contact_id]).contact_assignments
                              .where("effective_end_date < '31-dec-9999'")
                              .order("effective_end_date").last
    @contact_assignment.effective_end_date = '31-dec-9999'
    respond_to do |format|
      if @contact_assignment.save
        format.json {redirect_to contacts_url, notice: 'Contact assignment was successfully updated.' }
      else
        format.json { render json: @contact_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact_assignment
    @contact_assignment = ContactAssignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_assignment_params
    params.require(:contact_assignment).permit(:effective_start_date, :effective_end_date, :title, :address, :city, :state, :zip, :business_email, :office_phone, :fax, :organization_id, :contact_id)
  end

end