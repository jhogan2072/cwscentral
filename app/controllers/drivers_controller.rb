class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver, only: [:edit, :update, :destroy]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all.order(:name)
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        flash[:notice] = 'Driver was successfully created.'
        format.html { redirect_to action: "index" }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        flash[:notice] = 'Driver was successfully updated.'
        format.html { redirect_to action: "index" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      flash[:notice] = 'Driver was successfully deleted.'
      format.html { redirect_to drivers_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def driver_params
    params.require(:driver).permit(:name)
  end
end
