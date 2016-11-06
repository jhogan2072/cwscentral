class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.get_assignment_info
    @contacts = Contact.display_active
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
    @current_assignment_id = @contact.current_assignment_id
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_url, notice: 'Contact was successfully created.' }
      else
        format.html { render :new }
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
    else
      if new_assignment_index > -1
        cp[:contact_assignments_attributes].values[new_assignment_index]["effective_end_date"] = "9999-12-31"
      end
    end
    respond_to do |format|
      if @contact.update(cp)
        format.html { redirect_to edit_contact_url, notice: 'Contact was successfully updated.' }
      else
        format.html { render :edit }
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

  def import
    if request.method == "GET"
      @contact_staging = ContactStaging.all.order(:last_name).order(:first_name)
    elsif request.method == "POST"
      ContactStaging.import(params[:file_content])
      redirect_to import_contacts_url, notice: "Contacts imported to staging."
    end
  end

  def commit
    # Insert all the records in contact_stagings into contacts and contact_assignments
    contact_list = ContactStaging.all

    contact_list.each do |staging_contact|
      if !staging_contact.duplicate
        organization_id = Organization.where(name: staging_contact.organization_name).pluck(:id).first
        contact_exists = Contact.where(first_name: staging_contact.first_name).where(last_name: staging_contact.last_name)
        existing_contact_id = -1
        if contact_exists.pluck(:id).first
          existing_contact_id = contact_exists.pluck(:id).first
        end
        new_contact = Contact.new(
            dear: staging_contact.dear,
            first_name: staging_contact.first_name,
            last_name: staging_contact.last_name,
            salutation: staging_contact.salutation,
            personal_mobile: staging_contact.personal_mobile,
            start_date: staging_contact.start_date)
        new_contact.save
        new_contact_assignment = ContactAssignment.new(
            effective_start_date: staging_contact.start_date,
            effective_end_date: "31-DEC-9999",
            organization_id: organization_id,
            contact_id: existing_contact_id > 0 ? existing_contact_id : new_contact.id,
            title: staging_contact.title,
            department: staging_contact.department,
            address: staging_contact.address,
            city: staging_contact.city,
            state: staging_contact.state,
            zip: staging_contact.zip,
            business_email: staging_contact.business_email,
            office_phone: staging_contact.office_phone,
            fax: staging_contact.fax,
            role: staging_contact.role
        )
        new_contact_assignment.save
      end
    end
  ensure
    contact_list.delete_all

    redirect_to import_contacts_url, notice: "Contacts imported!"
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
