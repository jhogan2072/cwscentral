class ContactStagingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @contact_staging.update(contact_staging_params)
        format.html { redirect_to import_contacts_url, notice: 'Contact staging record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact_staging = ContactStaging.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_staging_params
    params.require(:contact_staging).permit(:first_name, :last_name, :salutation, :dear, :personal_mobile, :start_date,
                                            :organization_name, :title, :department, :address, :city, :state, :zip,
                                            :business_email, :office_phone, :fax, :role, :duplicate)
  end
end
