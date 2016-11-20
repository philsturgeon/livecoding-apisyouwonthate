class ManufacturersController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :manufacturer_not_found
  end

  def index
    manufacturers = Manufacturer.take(10)
    render json: manufacturers
  end

  def show
    manufacturer = Manufacturer.find(params[:id])
    render json: manufacturer
  end

  def create
    manufacturer = Manufacturer.new(create_params)

    if !manufacturer.save
      render_json_validation_error manufacturer
      return
    end

    render json: manufacturer.reload, status: :created
  end

  def update
    manufacturer = Manufacturer.find(params[:id])

    if !manufacturer.update(update_params)
      render_json_validation_error manufacturer
      return
    end

    render json: manufacturer, status: :ok
  end

  def destroy
    manufacturer = Manufacturer.find(params[:id])
    manufacturer.destroy!
    head :no_content
  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields)
  end

  def update_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields)
  end

  def allowed_fields
    [:name, :about, :city, :country]
  end
end
