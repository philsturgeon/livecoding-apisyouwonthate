require "rails_helper"

RSpec.describe ProductsController do

  let(:valid_contract) do
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
    it 'will be ok' do
      get products_url
      expect(response).to have_http_status(:ok)
    end

    context 'when we only have one item' do
      let!(:product) { create(:product) }

      it 'will retrieve records in valid JSON-API format' do
        get products_url
        puts response.body.inspect
        expect(response.body).to include_json(data: [valid_contract])
      end
    end

    context 'when you have 20 records (twice the pagination limit)' do
      before do
        create_list(:product, 20)
      end

      it 'will only return 10 results' do
        get products_url
        results = JSON.parse(response.body)
        expect(results["data"].size).to eql(10)
      end
    end
  end

  describe 'GET /products/{id}' do
    context 'when product exists' do
      let(:product) { create(:product) }

      before { get product_url(product) }

      it 'will be ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'will be JSON' do
        expect(response.content_type).to eql('application/json')
      end

      it 'will retrieve record in valid JSON-API format' do
        expect(response.body).to include_json(data: valid_contract)
      end
    end

    context 'when product does not exist' do
      before { get product_url("nonsense") }

      it 'will not be found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find product",
          "status"=>404,
          "code"=>"product_not_found",
          "detail"=>"This product does not exist, or has been deleted. Product can be removed by manufacturers or admins."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end

  describe 'POST /products' do
    let(:valid_payload) do
      {
        data: {
          type: "product",
          attributes: {
            name: "New Thing 2",
            description: "BLWDFSDFKSDJFSDJF.",
            type: "cider",
            apv: 6.4
          },
          relationships: {
            manufacturer: {
              data: { type: "manufacturer", id: 1 }
            }
          }
        }
      }
    end

    let(:invalid_payload) do
      {
        data: {
          type: "product",
          attributes: {
            description: "BLWDFSDFKSDJFSDJF.",
            type: "cider"
          }
        }
      }
    end

    context 'with valid payload' do
      before { post products_url, params: valid_payload }

      it 'will have a :created response' do
        expect(response).to have_http_status(:created)
      end

      it 'will respond with newly created product' do
        expect(response.body).to include_json(data: {
          attributes: {
            name: "New Thing 2",
            description: "BLWDFSDFKSDJFSDJF.",
          }
        })
      end
    end

    context 'with invalid payload' do
      before { post products_url, params: invalid_payload }

      it 'will have a :bad_request response' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'will respond with newly created product' do
        expect(response.body).to include_json(
          errors: [{
            source: { pointer: "/data/attributes/name" },
            detail: "can't be blank",
          }]
        )
      end
    end
  end

  describe 'PATCH /products/{id}' do
    let(:valid_payload) do
      {
        data: {
          id: "#{product.id}",
          type: "product",
          attributes: {
            name: "Updated Cider",
            description: "Some new name.",
            type: "cider",
            apv: 6.4
          },
          relationships: {
            manufacturer: {
              data: { type: "manufacturer", id: 1 }
            }
          }
        }
      }
    end

    let(:invalid_payload) do
      {
        data: {
          id: "#{product.id}",
          type: "product",
          attributes: {
            name: nil,
          }
        }
      }
    end

    context 'when product exists' do
      let(:product) { create(:product) }

      context 'with valid payload' do
        before { patch product_url(product), params: valid_payload }

        it 'will have an :ok response' do
          expect(response).to have_http_status(:ok)
        end

        it 'will respond with newly created product' do
          expect(response.body).to include_json(data: {
            attributes: {
              name: "Updated Cider",
              description: "Some new name.",
            }
          })
        end
      end

      context 'with invalid payload' do
        before { patch product_url(product), params: invalid_payload }

        it 'will have a :bad_request response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'will respond with newly updated product' do
          error = {
            source: { pointer: "/data/attributes/name" },
            detail: "can't be blank",
          }
          expect(response.body).to include_json(errors: [error])
        end
      end
    end

    context 'when product does not exist' do
      before { patch product_url('nonsense') }

      it 'will have a :not_found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find product",
          "status"=>404,
          "code"=>"product_not_found",
          "detail"=>"This product does not exist, or has been deleted. Product can be removed by manufacturers or admins."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end

  describe 'DELETE /products/{id}' do

    context 'when product exists' do
      let(:product) { create(:product) }

      before { delete product_url(product) }

      it 'will have a :no_content response' do
        expect(response).to have_http_status(:no_content)
      end

      it 'will respond with no body' do
        expect(response.body).to be_empty
      end
    end

    context 'when product does not exist' do
      before { delete product_url('nonsense') }

      it 'will have a :not_found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find product",
          "status"=>404,
          "code"=>"product_not_found",
          "detail"=>"This product does not exist, or has been deleted. Product can be removed by manufacturers or admins."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end
end
