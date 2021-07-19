require 'rails_helper'

RSpec.describe 'Merchant Items RESTful API Endpoint' do
  describe 'item index endpoint' do
    it 'sends items of a merchant data' do
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items_json = JSON.parse(response.body, symbolize_names: true)

      expect(items_json.size).to eq(1)
      expect(items_json).to be_a Hash
      expect(items_json[:data].size).to eq(2)
      expect(items_json[:data]).to be_an Array

      expect(items_json[:data].first.size).to eq(3)
      expect(items_json[:data].last.size).to eq(3)

      expect(items_json[:data].first).to have_key(:id)
      expect(items_json[:data].first[:id]).to be_a String

      expect(items_json[:data].first).to have_key(:type)
      expect(items_json[:data].first[:type]).to be_a String

      expect(items_json[:data].first).to have_key(:attributes)
      expect(items_json[:data].first[:attributes]).to be_a Hash
      expect(items_json[:data].first[:attributes].size).to eq(4)

      expect(items_json[:data].first[:attributes][:name]).to be_a String
      expect(items_json[:data].first[:attributes][:name]).to eq(items.first.name)

      expect(items_json[:data].first[:attributes]).to have_key(:description)
      expect(items_json[:data].first[:attributes][:description]).to be_a String
      expect(items_json[:data].first[:attributes][:description]).to eq(items.first.description)

      expect(items_json[:data].first[:attributes]).to have_key(:unit_price)
      expect(items_json[:data].first[:attributes][:unit_price]).to be_a Float
      expect(items_json[:data].first[:attributes][:unit_price]).to eq(items.first.unit_price)

      expect(items_json[:data].first[:attributes]).to have_key(:merchant_id)
      expect(items_json[:data].first[:attributes][:merchant_id]).to be_an Integer
      expect(items_json[:data].first[:attributes][:merchant_id].to_i).to eq(items.first.merchant_id)
    end
  end
end
