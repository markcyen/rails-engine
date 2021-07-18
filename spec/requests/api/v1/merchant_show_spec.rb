require 'rails_helper'

RSpec.describe 'Merchant RESTful API Endpoint' do
  describe 'show endpoint' do
    it 'sends a merchant data' do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_json = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_json).to have_key(:id)
      expect(merchant_json[:id]).to eq(merchant.id)

      expect(merchant_json).to have_key(:name)
      expect(merchant_json[:name]).to eq(merchant.name)
    end
  end
end
