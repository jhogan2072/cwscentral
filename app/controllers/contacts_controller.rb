class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.all.order('last_name')
    @contacts = Contact.get_assignment_info.order('last_name')
    # respond_to do |format|
    #   format.html { render :index }
    #   format.json { render :json => @contacts.to_json(include: {contact_assignments: {include: :organization}}) }
    # end
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_url, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: contacts_url }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    new_assignment_index = -1
    original_assignment_index = -1
    contact_params[:contact_assignments_attributes].each_with_index  do |assignment, index|
      if assignment[1]["effective_end_date"] == ""
        new_assignment_index = index
      else
        if assignment[1]["effective_end_date"].to_s.split("-")[0] == "9999"
          original_assignment_index = index
        end
      end
    end
    cp = contact_params
    if new_assignment_index > -1 and original_assignment_index > -1
      cp[:contact_assignments_attributes].values[new_assignment_index]["effective_end_date"] = "9999-12-31"
      my_int = cp[:contact_assignments_attributes].values[new_assignment_index]["effective_start_date(3i)"].to_i - 1
      cp[:contact_assignments_attributes].values[original_assignment_index]["effective_end_date"] =
          cp[:contact_assignments_attributes].values[new_assignment_index]["effective_start_date(1i)"] + "-" +
              cp[:contact_assignments_attributes].values[new_assignment_index]["effective_start_date(2i)"] + "-" +
              my_int.to_s
    end
    respond_to do |format|
      if @contact.update(cp)
        format.html { redirect_to edit_contact_url, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: contacts_url }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @contacts = Contact.get_assignment_info
    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="all_contacts.xlsx"'}
    end
  end

  def placements
    #retrieve a students work history
    @placements = Placement.search(filtering_id=params[:id], query_type=2)
    if @placements.length == 0
      render json: :no_content, status: 404
    end
  end

  def incidents
    #retrieve a students incident history
    @incidents = Incident.search(filtering_id=params[:id], query_type=2)
    if @incidents.length == 0
      render json: :no_content, status: 404
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:salutation, :first_name, :last_name, :email, :mobile,
                                      contact_assignments_attributes: [:id, :effective_start_date, :effective_end_date,
                                                                       :organization_id, :title, :role, :address,
                                                                      :city, :state, :zip, :business_email, :office_phone,
                                                                       :fax, :notes, :_destroy])
    end
end
