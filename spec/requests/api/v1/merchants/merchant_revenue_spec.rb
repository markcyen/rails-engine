require 'rails_helper'

RSpec.describe 'Non-ReSTful API Revenue Endpoint' do
  describe 'merchant revenue endpoint' do
    it 'can send revenue for a given merchant' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'shipped')
      create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 10, unit_price: item_1.unit_price)
      create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 15, unit_price: item_2.unit_price)
      create(:transaction, result: "success", invoice: invoice_1)
      create(:transaction, result: "failed", invoice: invoice_2)

      merchant_2 = create(:merchant)
      item_4 = create(:item, unit_price: 129.52, merchant: merchant_2)
      invoice_3 = create(:invoice, merchant: merchant_2, status: 'shipped')
      create(:invoice_item, item: item_4, invoice: invoice_3, quantity: 7, unit_price: item_4.unit_price)
      create(:transaction, result: "success", invoice: invoice_3)

      get "/api/v1/revenue/merchants/#{merchant_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_1_revenue_json = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_1_revenue_json[:data][:id].to_i).to eq(merchant_1.id)
      expect(merchant_1_revenue_json[:data][:type]).to eq("merchant_revenue")
      expect(merchant_1_revenue_json[:data][:attributes][:revenue]).to eq(12599.40)
    end
  end
end
