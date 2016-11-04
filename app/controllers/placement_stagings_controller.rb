class PlacementStagingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_placement, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @placement_staging.update(placement_staging_params)
        format.html { redirect_to import_placements_url, notice: 'Placement staging record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_placement
    @placement_staging = PlacementStaging.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def placement_staging_params
    params.require(:placement_staging).permit(:student_first_name, :student_last_name, :student_middle_name, :contact_first_name,
                                              :contact_last_name, :organization_name, :start_date, :end_date, :paid, :work_day,
                                              :student_gradelevel, :earliest_start, :latest_start, :ideal_start, :duplicate)
  end
end
