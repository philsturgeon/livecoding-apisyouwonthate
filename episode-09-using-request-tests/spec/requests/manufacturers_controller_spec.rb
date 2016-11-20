require "rails_helper"

RSpec.describe ManufacturersController do


  let(:valid_contract) do
    {
      id: "#{manufacturer.id}",
      type: "manufacturer",
      attributes: {
        name: "#{manufacturer.name}",
        about: "#{manufacturer.about}",
        city: "#{manufacturer.city}",
        country: "#{manufacturer.country}",
      },
      links: {
        self: "http://localhost:3000/manufacturers/#{manufacturer.id}",
        products: "http://localhost:3000/products?manufacturer_id=#{manufacturer.id}",
      }
    }
  end

  describe 'GET /manufacturers' do

    it 'will have an :ok response' do
      get manufacturers_url
      expect(response).to have_http_status(:ok)
    end

    context 'when we only have one item' do
      let!(:manufacturer) { create(:manufacturer) }

      it 'will retrieve records in valid JSON-API format' do
        get manufacturers_url
        expect(response.body).to include_json(data: [valid_contract])
      end
    end

    context 'when you have 20 records (twice the pagination limit)' do
      before { create_list(:manufacturer, 20) }

      it 'will only return 10 results' do
        get manufacturers_url
        results = JSON.parse(response.body)
        expect(results["data"].size).to eql(10)
      end
    end
  end

  describe 'GET /manufacturers/{id}' do
    context 'when manufacturer exists' do
      let(:manufacturer) { create(:manufacturer) }

      before { get manufacturer_url(manufacturer) }

      it 'will have an :ok response' do
        expect(response).to have_http_status(:ok)
      end

      it 'will retrieve record in valid JSON-API format' do
        expect(response.body).to include_json(data: valid_contract)
      end
    end

    context 'when manufacturer does not exist' do
      before { get manufacturer_url('nonsense') }

      it 'will have a :not_found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end

  describe 'POST /manufacturers' do
    let(:valid_payload) do
      {
        data: {
          type: "manufacturer",
          attributes: {
            name: "Kopparberg",
            about: "Made out of candyfloss and rainbows.",
            city: "Somewhere",
            country: "Over The Rainbow"
          }
        }
      }
    end

    let(:invalid_payload) do
      {
        data: {
          type: "manufacturer",
          attributes: {
            city: ""
          }
        }
      }
    end

    context 'with valid payload' do
      before { post manufacturers_url, params: valid_payload }

      it 'will have a :created response' do
        expect(response).to have_http_status(:created)
      end

      it 'will respond with newly created manufacturer' do
        expect(response.body).to include_json(data: {
          attributes: {
            name: "Kopparberg",
            about: "Made out of candyfloss and rainbows.",
          }
        })
      end
    end

    context 'with invalid payload' do
      before { post manufacturers_url, params: invalid_payload }

      it 'will have a :bad_request response' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'will respond with newly created manufacturer' do
        expect(response.body).to include_json(
          errors: [{
            source: { pointer: "/data/attributes/name" },
            detail: "can't be blank",
          }]
        )
      end
    end
  end

  describe 'PATCH /manufacturers/{id}' do
    let(:valid_payload) do
      {
        data: {
          id: "#{manufacturer.id}",
          type: "manufacturer",
          attributes: {
            about: "Something less sweet.",
            city: "cider",
            country: 6.4
          }
        }
      }
    end

    let(:invalid_payload) do
      {
        data: {
          id: "#{manufacturer.id}",
          type: "manufacturer",
          attributes: {
            name: nil,
          }
        }
      }
    end

    context 'when manufacturer exists' do
      let(:manufacturer) { create(:manufacturer) }

      context 'with valid payload' do
        before { patch manufacturer_url(manufacturer), params: valid_payload }

        it 'will have an :ok response' do
          expect(response).to have_http_status(:ok)
        end

        it 'will respond with newly created manufacturer' do
          expect(response.body).to include_json(data: {
            attributes: {
              about: "Something less sweet.",
            }
          })
        end
      end

      context 'with invalid payload' do
        before { patch manufacturer_url(manufacturer), params: invalid_payload }

        it 'will have a :bad_request response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'will respond with newly updated manufacturer' do
          error = {
            source: { pointer: "/data/attributes/name" },
            detail: "can't be blank",
          }
          expect(response.body).to include_json(errors: [error])
        end
      end
    end

    context 'when manufacturer does not exist' do
      before { patch manufacturer_url('nonsense') }

      it 'will have a :not_found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end

  describe 'DELETE /manufacturers/{id}' do

    context 'when manufacturer exists' do
      let(:manufacturer) { create(:manufacturer) }

      before { delete manufacturer_url(manufacturer) }

      it 'will have a :no_content response' do
        expect(response).to have_http_status(:no_content)
      end

      it 'will respond with no body' do
        expect(response.body).to be_empty
      end
    end

    context 'when manufacturer does not exist' do
      before { delete manufacturer_url('nonsense') }

      it 'will have a :not_found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(response.body).to include_json(errors: [error])
      end
    end
  end
end
