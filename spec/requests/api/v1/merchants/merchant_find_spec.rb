require 'rails_helper'

RSpec.describe 'API Non-ReSTful' do
  describe 'find merchant' do
    it 'can send merchant API by name case-sensitive search' do
      merchant_1 = Merchant.create(name: 'Turing')
      merchant_2 = Merchant.create(name: 'Ring World')

      get '/api/v1/merchants/find', params: { name: 'Ring' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(find_merchant[:data][:attributes][:name]).to eq(merchant_2.name)
    end

    it 'can send merchant API by name case-insensitive search' do
      merchant_1 = Merchant.create(name: 'Turing')
      merchant_2 = Merchant.create(name: 'Ring World')

      get '/api/v1/merchants/find', params: { name: 'ring' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(find_merchant[:data][:attributes][:name]).to eq(merchant_1.name)
    end

    it 'can send error when there is no params' do
      merchant_1 = Merchant.create(name: 'Turing')
      merchant_2 = Merchant.create(name: 'Ring World')

      get '/api/v1/merchants/find'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(find_merchant[:data]).to eq({})
      expect(find_merchant[:status]).to eq(400)
      expect(find_merchant[:message]).to eq("No required query name input.")
    end

    it 'can send error when there is no params' do
      merchant_1 = Merchant.create(name: 'Turing')
      merchant_2 = Merchant.create(name: 'Ring World')

      get '/api/v1/merchants/find', params: { name: "" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(find_merchant[:data]).to eq({})
      expect(find_merchant[:status]).to eq(400)
      expect(find_merchant[:message]).to eq("No required query name input.")
    end

    it 'can send error when there is no params' do
      merchant_1 = Merchant.create(name: 'Turing')
      merchant_2 = Merchant.create(name: 'Ring World')

      get '/api/v1/merchants/find', params: { name: "ted" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      find_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(find_merchant[:data]).to eq({})
      expect(find_merchant[:status]).to eq(400)
      expect(find_merchant[:message]).to eq("No required query name input.")
    end
  end
end
