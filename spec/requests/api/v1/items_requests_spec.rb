require 'rails_helper'

RSpec.describe 'Items API' do
  before :all do
    merchant = create(:merchant)
    items = create_list(:item, 63, merchant: merchant)
  end

  describe 'default' do
    it 'sends a list of twenty items for default query params' do
      get '/api/v1/items'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an Array
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end

  describe 'default page, limit query greater than 20' do
    it 'sends a list of twenty items for default page one with limit as query param' do
      get '/api/v1/items', params: { per_page: 35 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(35)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end

  describe 'default limit, page zero' do
    it 'sends a list of twenty merchants for default limit of twenty with page zero' do
      get '/api/v1/items', params: { page: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(20)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end

  describe 'default limit, negative page number' do
    it 'sends error message in response body' do
      get '/api/v1/items', params: { page: -1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:status]).to eq(400)
      expect(items[:message]).to eq("Negative or zero query results to error.")
    end
  end

  describe 'default limit, page two' do
    it 'sends a list of twenty items for default limit of twenty with page two' do
      get '/api/v1/items', params: { page: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(20)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end

  describe 'limit query, default page' do
    it 'sends a list of items based on limit query and default page one' do
      get '/api/v1/items', params: { per_page: 39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(39)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end

    it 'sends error in response body when limit query is negative and default page one' do
      get '/api/v1/items', params: { per_page: -39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:status]).to eq(400)
      expect(items[:message]).to eq("Negative query results to error.")
    end
  end

  describe 'both query params' do
    it 'sends list of items based on both query params' do
      get '/api/v1/items', params: { per_page: 15, page: 3 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(15)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end

  describe 'query large limit' do
    it 'sends list of items based on both query params' do
      get '/api/v1/items', params: { per_page: 100 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(63)
      expect(items[:data].last[:id].to_i).to eq(Item.last.id)
    end
  end
end
