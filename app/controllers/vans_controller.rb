class VansController < ApplicationController
  before_action :set_van, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /vans
  # GET /vans.json
  def index
    @vans = Van.all
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
        format.html { redirect_to @van, notice: 'Van was successfully created.' }
        format.json { render :show, status: :created, location: @van }
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
        format.html { redirect_to @van, notice: 'Van was successfully updated.' }
        format.json { render :show, status: :ok, location: @van }
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
      format.html { redirect_to vans_url, notice: 'Van was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_van
    @van = Van.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def van_params
    params.require(:van).permit(:name, :plate_number, :vin, :make, :model_year, :last_oil_change)
  end
end
