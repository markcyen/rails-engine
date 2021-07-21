require 'rails_helper'

RSpec.describe 'Merchants Non-ReSTful API Most Revenue Endpoint' do
  describe 'top merchants revenue endpoint' do
    it 'can send revenue of top merchants' do
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

      get "/api/v1/revenue/merchants", params: { quantity: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_merchant_revenue_json = JSON.parse(response.body, symbolize_names: true)

      expect(top_merchant_revenue_json[:data].first[:type]).to eq("merchant_name_revenue")
      expect(top_merchant_revenue_json[:data].first[:attributes][:name]).to eq(merchant_1.name)
      expect(top_merchant_revenue_json[:data].first[:attributes][:revenue]).to eq(Merchant.top_revenue(1).first.revenue)

      expect(top_merchant_revenue_json[:data].second[:type]).to eq("merchant_name_revenue")
      expect(top_merchant_revenue_json[:data].second[:attributes][:name]).to eq(merchant_2.name)
      expect(top_merchant_revenue_json[:data].second[:attributes][:revenue]).to eq(Merchant.top_revenue(2).second.revenue)
    end
  end

  describe 'top merchants revenue endpoint' do
    it 'can send error message for sad path' do
      merchant_2 = create(:merchant)
      item_4 = create(:item, unit_price: 129.52, merchant: merchant_2)
      invoice_3 = create(:invoice, merchant: merchant_2, status: 'shipped')
      create(:invoice_item, item: item_4, invoice: invoice_3, quantity: 7, unit_price: item_4.unit_price)
      create(:transaction, result: "success", invoice: invoice_3)

      get "/api/v1/revenue/merchants", params: { quantity: 0 }

      sad_path_1 = JSON.parse(response.body, symbolize_names: true)

      expect(sad_path_1[:status]).to eq(400)
      expect(sad_path_1[:message]).to eq("Need a relevant quantity input.")

      get "/api/v1/revenue/merchants", params: { quantity: -1 }

      sad_path_2 = JSON.parse(response.body, symbolize_names: true)

      expect(sad_path_2[:status]).to eq(400)
      expect(sad_path_2[:message]).to eq("Need a relevant quantity input.")
    end
  end
end
