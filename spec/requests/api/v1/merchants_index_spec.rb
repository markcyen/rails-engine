require 'rails_helper'

describe 'Merchants API' do
  describe 'default' do
    it 'sends a list of twenty merchants for default query params' do
      create_list(:merchant, 41)

      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.size).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer)

        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
      end
    end
  end

  describe 'default page, limit query greater than 20' do
    it 'sends a list of twenty merchants for default page one with limit as query param' do
      create_list(:merchant, 41)

      get '/api/v1/merchants', params: { data_limit: 35 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.size).to eq(20)
      expect(merchants.last[:id]).to eq(20)
    end
  end

  describe 'default limit, page zero' do
    it 'sends a list of twenty merchants for default limit of twenty with page zero' do
      create_list(:merchant, 41)

      get '/api/v1/merchants', params: { page: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.size).to eq(20)
      expect(merchants.last[:id]).to eq(20)
    end
  end

  describe 'default limit, page two' do
    it 'sends a list of twenty merchants for default limit of twenty with page two' do
      create_list(:merchant, 41)

      get '/api/v1/merchants', params: { page: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.size).to eq(20)
      expect(merchants.last[:id]).to eq(40)
    end
  end

end
