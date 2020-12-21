require 'rails_helper'

RSpec.describe 'ExchangeRates API', type: :request do
  # initialize test data
  let!(:exchange_rates) { create_list(:exchange_rate, 10) }
  let(:exchange_rate_id) { exchange_rates.first.id }

  # Test suite for GET /exchange_rates
  describe 'GET /exchange_rates' do
    # make HTTP get request before each example
    before { get '/exchange_rates', params: {}, headers: headers }

    it 'returns exchange_rates' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /exchange_rates/:id
  describe 'GET /exchange_rates/:id' do
    before { get "/exchange_rates/#{exchange_rate_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the exchange_rate' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(exchange_rate_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:exchange_rate_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ExchangeRate/)
      end
    end
  end

  # Test suite for POST /exchange_rates
  describe 'POST /exchange_rates' do
    # valid payload
    let(:valid_attributes) do
      {
        source: 'cc',
        base_currency: 'PLN',
        foreign_currency: 'EUR',
        buying_rate: BigDecimal("4.4536"),
        selling_rate: BigDecimal("4.4941"),
        average_rate: BigDecimal("4.5138"),
        refreshed_at: Time.zone.parse("14:00:00").as_json,
        created_by: user.id.to_s
      }.to_json
    end

    context 'when the request is valid' do
      before { post '/exchange_rates', params: valid_attributes, headers: headers }

      it 'creates a exchange_rate' do
        expect(json['source']).to eq('cc')
        expect(json['base_currency']).to eq('PLN')
        expect(json['foreign_currency']).to eq('EUR')
        expect(json['buying_rate']).to eq('4.4536')
        expect(json['selling_rate']).to eq('4.4941')
        expect(json['average_rate']).to eq('4.5138')
        expect(json['refreshed_at']).to eq(valid_attributes[:refreshed_at])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { source: nil}.to_json }
      before { post '/exchange_rates', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Base currency can't be blank/)
      end
    end
  end

  # Test suite for PUT /exchange_rates/:id
  describe 'PUT /exchange_rates/:id' do
    let(:valid_attributes) { { source: 'ik' }.to_json }

    context 'when the record exists' do
      before { put "/exchange_rates/#{exchange_rate_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /exchange_rates/:id
  describe 'DELETE /exchange_rates/:id' do
    before { delete "/exchange_rates/#{exchange_rate_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
