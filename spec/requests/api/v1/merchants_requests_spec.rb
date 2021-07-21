require 'rails_helper'

RSpec.describe 'Merchants API' do
  before :all do
    create_list(:merchant, 61)
  end

  describe 'default' do
    it 'sends a list of twenty merchants for default query params' do
      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_an Array
      expect(merchants[:data].last[:id].to_i).to eq(20)
    end
  end

  describe 'default page, limit query greater than 20' do
    it 'sends a list of twenty merchants for default page one with limit as query param' do
      get '/api/v1/merchants', params: { per_page: 35 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].size).to eq(35)
      expect(merchants[:data].last[:id].to_i).to eq(35)
    end
  end

  describe 'default limit, page zero' do
    it 'sends a list of twenty merchants for default limit of twenty with page zero' do
      get '/api/v1/merchants', params: { page: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].last[:id].to_i).to eq(20)
    end
  end

  describe 'default limit, negative page number' do
    it 'sends error message in response body' do
      get '/api/v1/merchants', params: { page: -1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:status]).to eq(400)
      expect(merchants[:message]).to eq("Negative or zero query results to error.")
    end
  end

  describe 'default limit, page two' do
    it 'sends a list of twenty merchants for default limit of twenty with page two' do
      get '/api/v1/merchants', params: { page: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].size).to eq(20)
      expect(merchants[:data].last[:id].to_i).to eq(40)
    end
  end

  describe 'limit query, default page' do
    it 'sends a list of merchants based on limit query and default page one' do
      get '/api/v1/merchants', params: { per_page: 39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].size).to eq(39)
      expect(merchants[:data].last[:id].to_i).to eq(39)
    end

    it 'sends error in response body when limit query is negative and default page one' do
      get '/api/v1/merchants', params: { per_page: -39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:status]).to eq(400)
      expect(merchants[:message]).to eq("Negative query results to error.")
    end
  end

  describe 'both query params' do
    it 'sends list of merchants based on both query params' do
      get '/api/v1/merchants', params: { per_page: 15, page: 3 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].size).to eq(15)
      expect(merchants[:data].last[:id].to_i).to eq(45)
    end
  end
end
