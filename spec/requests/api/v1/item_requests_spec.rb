require 'rails_helper'

RSpec.describe 'Item RESTful API Endpoints' do
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

  describe 'create endpoint' do
    it 'can create a new item' do
      merchant = create(:merchant)
      item_params = ({
        name: 'Sunflower Seeds',
        description: 'Tasty roasted and salted sunflower seeds',
        unit_price: 203,
        merchant_id: merchant.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
    end
  end
end
