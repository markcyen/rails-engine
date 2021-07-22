require 'rails_helper'

RSpec.describe 'API Non-ReSTful' do
  describe 'find all items' do
    it 'can send all items API by name case-sensitive search' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_1)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_1)

      get '/api/v1/items/find_all', params: { name: 'cream' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_all_items = JSON.parse(response.body, symbolize_names: true)

      expect(find_all_items[:data].first[:attributes][:name]).to eq(item_1.name)
      expect(find_all_items[:data].second[:attributes][:name]).to eq(item_4.name)
    end

    it 'can send all items API by name case-sensitive search' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_1)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_1)

      get '/api/v1/items/find_all', params: { name: 'Cream' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_all_items = JSON.parse(response.body, symbolize_names: true)

      expect(find_all_items[:data].first[:attributes][:name]).to eq(item_3.name)
    end

    it 'can send empty endpoint with empty string input for name' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_1)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_1)

      get '/api/v1/items/find_all', params: { name: '' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_all_items = JSON.parse(response.body, symbolize_names: true)

      expect(find_all_items[:data]).to eq([])
    end

    it 'can send empty endpoint with no name query' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_1)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_1)

      get '/api/v1/items/find_all'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_all_items = JSON.parse(response.body, symbolize_names: true)

      expect(find_all_items[:data]).to eq([])
    end
  end
end
