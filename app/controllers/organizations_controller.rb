class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all.order(:name)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to :back, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @organizations = Organization.all
    respond_to do |format|
      format.csv { send_data @organizations.to_csv }
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="all_orgs.xlsx"'}
    end
  end

  def incidents
    #retrieve an organizations student incident history
    @incidents = Incident.search(filtering_id=params[:id], query_type=1)
    if @incidents.length == 0
      render json: :no_content, status: 404
    end
  end

  def placements
    #retrieve an organizations student work history
    @placements = Placement.search(filtering_id=params[:id], query_type=1)
    if @placements.length == 0
      render json: :no_content, status: 404
    end
  end

  def import
    if request.method == "GET"
      @org_staging = OrgStaging.all.order(:name)
    elsif request.method == "POST"
      OrgStaging.import(params[:file_content])
      redirect_to import_organizations_url, notice: "Organizations imported to staging."
    end
  end

  def commit
    # Insert all the records in org_stagings into organizations
    org_list = OrgStaging.all
    org_list.each do |staging_org|
      if !staging_org.duplicate
        new_org = Organization.new(
            name: staging_org.name,
            billing_address: staging_org.billing_address,
            city: staging_org.city,
            state: staging_org.state,
            zip: staging_org.zip,
            sponsor_since: staging_org.sponsor_since)

        new_org.save
      end
    end
  ensure
    org_list.delete_all

    redirect_to import_organizations_url, notice: "Organizations imported!"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :billing_address, :city, :state, :zip, :sponsor_since, :sugarcrm_id)
    end
end
