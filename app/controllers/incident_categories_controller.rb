class IncidentCategoriesController < ApplicationController
  before_action :set_incident_category, only: [:show, :edit, :update, :destroy]

  # GET /incident_categories
  # GET /incident_categories.json
  def index
    @incident_categories = IncidentCategory.all
  end

  # GET /incident_categories/1
  # GET /incident_categories/1.json
  def show
  end

  # GET /incident_categories/new
  def new
    @incident_category = IncidentCategory.new
  end

  # GET /incident_categories/1/edit
  def edit
  end

  # POST /incident_categories
  # POST /incident_categories.json
  def create
    @incident_category = IncidentCategory.new(incident_category_params)

    respond_to do |format|
      if @incident_category.save
        format.html { redirect_to @incident_category, notice: 'Incident category was successfully created.' }
        format.json { render :show, status: :created, location: @incident_category }
      else
        format.html { render :new }
        format.json { render json: @incident_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incident_categories/1
  # PATCH/PUT /incident_categories/1.json
  def update
    respond_to do |format|
      if @incident_category.update(incident_category_params)
        format.html { redirect_to @incident_category, notice: 'Incident category was successfully updated.' }
        format.json { render :show, status: :ok, location: @incident_category }
      else
        format.html { render :edit }
        format.json { render json: @incident_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incident_categories/1
  # DELETE /incident_categories/1.json
  def destroy
    @incident_category.destroy
    respond_to do |format|
      format.html { redirect_to incident_categories_url, notice: 'Incident category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident_category
      @incident_category = IncidentCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def incident_category_params
      params.require(:incident_category).permit(:category)
    end
end