require 'rails_helper'

RSpec.describe 'Item RESTful API Endpoint' do
  describe 'show endpoint' do
    it 'sends an item data' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_json = JSON.parse(response.body, symbolize_names: true)

      expect(item_json).to have_key(:id)
      expect(item_json[:id]).to eq(item.id)

      expect(item_json).to have_key(:name)
      expect(item_json[:name]).to eq(item.name)

      expect(item_json).to have_key(:description)
      expect(item_json[:description]).to eq(item.description)

      expect(item_json).to have_key(:unit_price)
      expect(item_json[:unit_price]).to eq(item.unit_price)
    end
  end
end
