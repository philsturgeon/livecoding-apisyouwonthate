require "rails_helper"

RSpec.describe ProductsController do
  let(:product_json) do
    {
      id: "#{product.id}",
      type: "product",
      attributes: {
        name: "#{product.name}",
        description: "#{product.description}",
        type: "#{product.product_type}",
        apv: product.apv,
      },
      relationships: {
        manufacturer: []
      },
      links: {
        self: "http://localhost:3000/products/#{product.id}",
        manufacturer: "http://localhost:3000/manufacturers/#{product.manufacturer_id}",
      }
    }
  end

  describe 'GET /products' do
    subject { get :index }

    it { is_expected.to have_http_status(:ok) }

    context 'when we only have one item' do
      let!(:product) { create(:product) }

      it 'will retrieve records in valid JSON-API format' do
        expect(subject.body).to include_json(data: [product_json])
      end
    end

    context 'when you have 20 records (twice the pagination limit)' do
      before do
        create_list(:product, 20)
      end

      it 'will only return 10 results' do
        results = JSON.parse(subject.body)
        expect(results["data"].size).to eql(10)
      end
    end
  end

  describe 'GET /products/{id}' do
    context 'when product exists' do
      let(:product) { create(:product) }

      subject { get :show, params: { id: "#{product.id}" } }

      it { is_expected.to have_http_status(:ok) }

      it 'will retrieve record in valid JSON-API format' do
        expect(subject.body).to include_json(data: product_json)
      end
    end

    context 'when product exists' do
      subject { get :show, params: { id: "nonsense" } }

      it { is_expected.to have_http_status(:not_found) }

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find product",
          "status"=>404,
          "code"=>"product_not_found",
          "detail"=>"This product does not exist, or has been deleted. Product can be removed by manufacturers or admins."
        }
        expect(subject.body).to include_json(errors: [error])
      end
    end
  end
end
