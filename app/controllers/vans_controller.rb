class VansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_van, only: [:show, :edit, :update, :destroy]

  # GET /vans
  # GET /vans.json
  def index
    @vans = Van.all.order(:name)
  end

  # GET /vans/1
  # GET /vans/1.json
  def show
  end

  # GET /vans/new
  def new
    @van = Van.new
  end

  # GET /vans/1/edit
  def edit
  end

  # POST /vans
  # POST /vans.json
  def create
    @van = Van.new(van_params)

    respond_to do |format|
      if @van.save
        flash[:notice] = 'Van was successfully created.'
        format.html { redirect_to action: "index" }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @van.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vans/1
  # PATCH/PUT /vans/1.json
  def update
    respond_to do |format|
      if @van.update(van_params)
        flash[:notice] = 'Van was successfully updated.'
        format.html { redirect_to action: "index" }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @van.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vans/1
  # DELETE /vans/1.json
  def destroy
    @van.destroy
    respond_to do |format|
      flash[:notice] = 'Van was successfully deleted.'
      format.html { redirect_to vans_url }
      format.json { head :no_content }
    end
  end

  def export
    @vans = Van.all
    respond_to do |format|
      format.csv { send_data @vans.to_csv }
      format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="all_vans.xlsx"'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_van
    @van = Van.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def van_params
    params.require(:van).permit(:name, :plate_number, :vin, :make, :model_year, :last_oil_change, :capacity)
  end
end
