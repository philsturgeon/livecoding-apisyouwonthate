class ProductsController < ApplicationController

  include Roar::Rails::ControllerAdditions
  respond_to :json_api

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :product_not_found
  end

  def index
    products = Product.take(10)
    respond_with products, represent_with: ProductRepresenter.for_collection
  end

  def show
    product = Product.find(params[:id])
    respond_with product
  end

  def create
    product = Product.new
    consume!(product)
    respond_with product.reload, status: :created
  end

  def update
    product = Product.find(params[:id])
    consume!(product)
    respond_with product, status: :ok
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy!
    head :no_content
  end
end
