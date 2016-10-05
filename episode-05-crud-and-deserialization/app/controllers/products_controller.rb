class ProductsController < ApplicationController

  rescue_from 'ActiveRecord::RecordNotFound' do |e|
    render json: { errors: [{
      title: 'Could not find produt.',
      details: e.message
    }] }, status: :not_found
  end

  def index
    products = Product.all
    render json: products
  end

  def show
    product = Product.find(params[:id])
    render json: product
  end

  def create
    product = Product.new(create_params)

    if !product.save
      render status: :bad_request
      return
    end

    render json: product.reload, status: :ok
  end

  def update
    product = Product.find(params[:id])

    if !product.update(update_params)
      render status: :bad_request
      return
    end

    render json: product, status: :ok
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy!
    render nothing: true, status: :no_content
  end

  private

  def create_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields + [:manufacturer])
  end

  def update_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: allowed_fields)
  end

  def allowed_fields
    [:name, :description, :product_type, :apv]
  end
end
