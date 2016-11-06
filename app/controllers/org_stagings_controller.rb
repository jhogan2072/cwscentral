class OrgStagingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_org, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @org_staging.update(org_staging_params)
        format.html { redirect_to import_organizations_url, notice: 'Organization staging record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_org
    @org_staging = OrgStaging.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def org_staging_params
    params.require(:org_staging).permit(:name, :billing_address, :city, :state, :zip, :sponsor_since, :duplicate)
  end
end
