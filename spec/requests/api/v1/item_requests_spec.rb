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

      expect(item_json).to have_key(:merchant_id)
      expect(item_json[:merchant_id]).to eq(item.merchant_id)
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

  describe 'edit endpoint' do
    it 'can update an existing item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      previous_item_name = Item.last.name
      previous_item_description = Item.last.description
      previous_item_price = Item.last.unit_price
      item_1_params = ({
        name: 'Sunflower Seeds',
        description: 'Tasty roasted and salted sunflower seeds',
        unit_price: 203,
        merchant_id: merchant.id
        })

      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{Item.last.id}", headers: headers, params: JSON.generate({item: item_1_params})
      item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(item.name).to eq('Sunflower Seeds')
      expect(item.description).to eq('Tasty roasted and salted sunflower seeds')
      expect(item.unit_price).to eq(203)

      expect(item.name).to_not eq(previous_item_name)
      expect(item.description).to_not eq(previous_item_description)
      expect(item.unit_price).to_not eq(previous_item_price)
    end
  end

  describe 'delete endpoint' do
    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'merchant data from item ID' do
    it 'can send merchant data from item id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_json = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_json).to have_key(:data)
      expect(merchant_json[:data]).to be_a Hash

      expect(merchant_json[:data]).to have_key(:id)
      expect(merchant_json[:data][:id].to_i).to eq(merchant.id)

      expect(merchant_json[:data]).to have_key(:type)
      expect(merchant_json[:data][:type]).to eq("merchant")

      expect(merchant_json[:data]).to have_key(:attributes)
      expect(merchant_json[:data][:attributes]).to have_key(:name)
      expect(merchant_json[:data][:attributes][:name]).to eq(merchant.name)
    end
  end
end
