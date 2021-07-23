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

      expect(item_json.size).to eq(1)
      expect(item_json).to be_a Hash
      expect(item_json).to have_key(:data)
      expect(item_json[:data].size).to eq(3)
      expect(item_json[:data]).to be_a Hash

      expect(item_json[:data]).to have_key(:id)
      expect(item_json[:data][:id]).to be_a String

      expect(item_json[:data]).to have_key(:type)
      expect(item_json[:data][:type]).to be_a String
      expect(item_json[:data][:type]).to eq('item')

      expect(item_json[:data]).to have_key(:attributes)
      expect(item_json[:data][:attributes]).to be_a Hash
      expect(item_json[:data][:attributes].size).to eq(4)

      expect(item_json[:data][:attributes]).to have_key(:name)
      expect(item_json[:data][:attributes][:name]).to be_a String
      expect(item_json[:data][:attributes][:name]).to eq(item.name)

      expect(item_json[:data][:attributes]).to have_key(:description)
      expect(item_json[:data][:attributes][:description]).to be_a String
      expect(item_json[:data][:attributes][:description]).to eq(item.description)

      expect(item_json[:data][:attributes]).to have_key(:unit_price)
      expect(item_json[:data][:attributes][:unit_price]).to be_a Float
      expect(item_json[:data][:attributes][:unit_price]).to eq(item.unit_price)

      expect(item_json[:data][:attributes]).to have_key(:merchant_id)
      expect(item_json[:data][:attributes][:merchant_id]).to be_an Integer
      expect(item_json[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
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

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      # created_item = Item.last

      expect(response).to be_successful
      expect(response.status).to eq(201)

      created_item_json = JSON.parse(response.body, symbolize_names: true)

      expect(created_item_json).to have_key(:data)
      expect(created_item_json[:data]).to be_a Hash

      expect(created_item_json[:data].size).to eq(3)
      expect(created_item_json[:data]).to be_a Hash

      expect(created_item_json[:data]).to have_key(:id)
      expect(created_item_json[:data]).to have_key(:type)
      expect(created_item_json[:data][:type]).to eq('item')

      expect(created_item_json[:data]).to have_key(:attributes)
      expect(created_item_json[:data][:attributes]).to have_key(:name)
      expect(created_item_json[:data][:attributes][:name]).to be_a String
      expect(created_item_json[:data][:attributes][:name]).to eq(item_params[:name])

      expect(created_item_json[:data][:attributes]).to have_key(:description)
      expect(created_item_json[:data][:attributes][:description]).to be_a String
      expect(created_item_json[:data][:attributes][:description]).to eq(item_params[:description])

      expect(created_item_json[:data][:attributes]).to have_key(:unit_price)
      expect(created_item_json[:data][:attributes][:unit_price]).to be_a Float
      expect(created_item_json[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])

      expect(created_item_json[:data][:attributes]).to have_key(:merchant_id)
      expect(created_item_json[:data][:attributes][:merchant_id]).to be_an Integer
      expect(created_item_json[:data][:attributes][:merchant_id]).to eq(item_params[:merchant_id])
    end
  end

  describe 'edit endpoint' do
    it 'can update an existing item' do
      merchant_1 = create(:merchant)
      item = create(:item, merchant: merchant_1)

      merchant_2 = create(:merchant)

      previous_item_name = Item.last.name
      previous_item_description = Item.last.description
      previous_item_price = Item.last.unit_price
      previous_item_merchant = Item.last.merchant_id

      get "/api/v1/items/#{item.id}"

      item_json = JSON.parse(response.body, symbolize_names: true)

      expect(item_json[:data][:attributes][:name]).to eq(previous_item_name)
      expect(item_json[:data][:attributes][:description]).to eq(previous_item_description)
      expect(item_json[:data][:attributes][:unit_price]).to eq(previous_item_price)
      expect(item_json[:data][:attributes][:merchant_id]).to eq(previous_item_merchant)

      item_changed_params = ({
        name: 'Sunflower Seeds',
        description: 'Tasty roasted and salted sunflower seeds',
        unit_price: 203.0,
        merchant_id: merchant_2.id
        })

      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/items/#{Item.last.id}", headers: headers, params: JSON.generate({item: item_changed_params})
      # search_item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_changed_json = JSON.parse(response.body, symbolize_names: true)

      expect(item_changed_json[:data][:attributes][:name]).to eq(Item.last.name)
      expect(item_changed_json[:data][:attributes][:description]).to eq(Item.last.description)
      expect(item_changed_json[:data][:attributes][:unit_price]).to eq(Item.last.unit_price)
      expect(item_changed_json[:data][:attributes][:merchant_id]).to eq(Item.last.merchant_id)

      expect(item_changed_json[:data][:attributes][:name]).to_not eq(previous_item_name)
      expect(item_changed_json[:data][:attributes][:description]).to_not eq(previous_item_description)
      expect(item_changed_json[:data][:attributes][:unit_price]).to_not eq(previous_item_price)
      expect(item_changed_json[:data][:attributes][:merchant_id]).to_not eq(previous_item_merchant)
    end
  end

  describe 'delete endpoint' do
    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      expect(Item.count).to eq(1)

      get "/api/v1/items/#{item.id}"

      item_json = JSON.parse(response.body, symbolize_names: true)

      expect(item_json[:data][:attributes][:name]).to eq(item.name)
      expect(item_json[:data][:attributes][:description]).to eq(item.description)
      expect(item_json[:data][:attributes][:unit_price]).to eq(item.unit_price)
      expect(item_json[:data][:attributes][:merchant_id]).to eq(item.merchant_id)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Item.count).to eq(0)
      expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
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
      expect(merchant_json[:data][:type]).to eq('merchant')

      expect(merchant_json[:data]).to have_key(:attributes)
      expect(merchant_json[:data][:attributes]).to have_key(:name)
      expect(merchant_json[:data][:attributes][:name]).to eq(merchant.name)
    end
  end
end
