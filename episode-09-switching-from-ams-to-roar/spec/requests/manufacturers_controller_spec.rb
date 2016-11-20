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
    it 'is a success' do
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
      before do
        create_list(:manufacturer, 20)
      end

      it 'will only return 10 results' do
        results = JSON.parse(subject.body)
        expect(results["data"].size).to eql(10)
      end
    end
  end

  describe 'GET /manufacturers/{id}' do
    context 'when manufacturer exists' do
      let(:manufacturer) { create(:manufacturer) }

      subject { get :show, params: { id: "#{manufacturer.id}" } }

      it { is_expected.to have_http_status(:ok) }

      it 'will retrieve record in valid JSON-API format' do
        expect(subject.body).to include_json(data: valid_contract)
      end
    end

    context 'when manufacturer does not exist' do
      subject { get :show, params: { id: "nonsense" } }

      it { is_expected.to have_http_status(:not_found) }

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(subject.body).to include_json(errors: [error])
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
      subject { post :create, params: valid_payload }

      it { is_expected.to have_http_status(:created) }

      it 'will respond with newly created manufacturer' do
        expect(subject.body).to include_json(data: {
          attributes: {
            name: "Kopparberg",
            about: "Made out of candyfloss and rainbows.",
          }
        })
      end
    end

    context 'with invalid payload' do
      subject { post :create, params: invalid_payload }

      it { is_expected.to have_http_status(:bad_request) }

      it 'will respond with newly created manufacturer' do
        expect(subject.body).to include_json(
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
        subject { post :update, params: { id: "#{manufacturer.id}" }.merge(valid_payload) }

        it { is_expected.to have_http_status(:ok) }

        it 'will respond with newly created manufacturer' do
          expect(subject.body).to include_json(data: {
            attributes: {
              about: "Something less sweet.",
            }
          })
        end
      end

      context 'with invalid payload' do
        subject { post :update, params: { id: "#{manufacturer.id}" }.merge(invalid_payload) }

        it { is_expected.to have_http_status(:bad_request) }

        it 'will respond with newly updated manufacturer' do
          error = {
            source: { pointer: "/data/attributes/name" },
            detail: "can't be blank",
          }
          expect(subject.body).to include_json(errors: [error])
        end
      end
    end

    context 'when manufacturer does not exist' do
      subject { get :update, params: { id: "nonsense" } }

      it { is_expected.to have_http_status(:not_found) }

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(subject.body).to include_json(errors: [error])
      end
    end
  end

  describe 'DELETE /manufacturers/{id}' do

    context 'when manufacturer exists' do
      let(:manufacturer) { create(:manufacturer) }

      subject { delete :destroy, params: { id: "#{manufacturer.id}" } }

      it { is_expected.to have_http_status(:no_content) }

      it 'will respond with no body' do
        expect(subject.body).to be_empty
      end
    end

    context 'when manufacturer does not exist' do
      subject { delete :destroy, params: { id: "nonsense" } }

      it { is_expected.to have_http_status(:not_found) }

      it 'will return not found error message' do
        error = {
          "title"=>"Could not find manufacturer",
          "status"=>404,
          "code"=>"manufacturer_not_found",
          "detail"=>"This manufacturer is no longer available."
        }
        expect(subject.body).to include_json(errors: [error])
      end
    end
  end
end
