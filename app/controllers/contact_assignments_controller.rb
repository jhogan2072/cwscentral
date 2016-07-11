class ContactAssignmentsController < ApplicationController
  before_action :set_contact_assignment, only: [:show, :edit, :update, :destroy]

  # GET /contact_assignments
  # GET /contact_assignments.json
  def index
    @contact_assignments = ContactAssignment.all.order('effective_start_date')
  end

  # GET /contact_assignments/1
  # GET /contact_assignments/1.json
  def show
  end

  # GET /contact_assignments/new
  def new
    @contact_assignments = ContactAssignment.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contact_assignments
  # POST /contact_assignments.json
  def create
    @contact_assignments = ContactAssignment.new(contact_assignment_params)

    respond_to do |format|
      if @contact_assignments.save
        format.html { redirect_to @contact_assignments, notice: 'Contact assignment was successfully created.' }
        format.json { render :show, status: :created, location: @contact_assignments }
      else
        format.html { render :new }
        format.json { render json: @contact_assignments.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_assignments/1
  # PATCH/PUT /contact_assignments/1.json
  def update
    respond_to do |format|
      if @contact_assignment.update(contact_assignment_params)
        format.html { redirect_to @contact_assignment, notice: 'Contact assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_assignment }
      else
        format.html { render :edit }
        format.json { render json: @contact_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_assignments/1
  # DELETE /contact_assignments/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contact_assignments_url, notice: 'Contact assignment was successfully destroyed.' }
      format.json { head :no_content }
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