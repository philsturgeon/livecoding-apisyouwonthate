class ManufacturersController < ApplicationController
  def index
    manufacturers = Manufacturer.all
    render json: manufacturers
  end

  def show
    manufacturer = Manufacturer.find(params[:id])
    render json: manufacturer
  end
end
