class StudentsStagingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @students_staging.update(students_staging_params)
        format.html { redirect_to import_students_url, notice: 'Student staging record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @students_staging.destroy
    respond_to do |format|
      format.html { redirect_to import_students_url, notice: 'Student staging record was successfully deleted.' }
      format.json { head :no_content }
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @students_staging = StudentsStaging.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def students_staging_params
    params.require(:students_staging).permit(:first_name, :last_name, :middle_name, :classof, :skills, :goals, :active, :duplicate)
  end

end
