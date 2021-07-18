require 'rails_helper'

RSpec.describe 'Merchant Items RESTful API Endpoint' do
  describe 'item index endpoint' do
    it 'sends items of a merchant data' do
      merchant = create(:merchant)
      create_list(:item, 10, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items.count).to eq(10)
    end
  end
end
