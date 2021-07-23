require 'rails_helper'

RSpec.describe 'Invoices Non-ReSTful API' do
  before :each do
    FactoryBot.reload
    InvoiceItem.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Merchant.destroy_all
  end

  describe 'unshipped potential revenue' do
    it 'send potential revenue of unshipped orders based negative quantity' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped", params: { quantity: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:data].size).to eq(2)
      expect(top_orders[:data].first[:type]).to eq("unshipped_order")
      expect(top_orders[:data].first[:attributes]).to have_key(:potential_revenue)
      expect(top_orders[:data].first[:attributes][:potential_revenue].round(2)).to eq(7076.74)
      expect(top_orders[:data].second[:attributes][:potential_revenue].round(2)).to eq(5146.72)
    end

    it 'send potential revenue of unshipped orders based on param quantity zero' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped", params: { quantity: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:data].size).to eq(10)
      expect(top_orders[:data].first[:type]).to eq("unshipped_order")
      expect(top_orders[:data].first[:attributes]).to have_key(:potential_revenue)
      expect(top_orders[:data].first[:attributes][:potential_revenue].round(2)).to eq(7076.74)
      expect(top_orders[:data].last[:attributes][:potential_revenue].round(2)).to eq(1179.72)
    end

    it 'send potential revenue of unshipped orders based on no params' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:data].size).to eq(10)
      expect(top_orders[:data].first[:type]).to eq("unshipped_order")
      expect(top_orders[:data].first[:attributes]).to have_key(:potential_revenue)
      expect(top_orders[:data].first[:attributes][:potential_revenue].round(2)).to eq(7076.74)
      expect(top_orders[:data].last[:attributes][:potential_revenue].round(2)).to eq(1179.72)
    end

    it 'send error based on negative param quantity' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped", params: { quantity: -1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:status]).to eq(400)
      expect(top_orders[:message]).to eq("Need a relevant quantity input.")
    end

    it 'send error based on param quantity as a string' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped", params: { quantity: "hello world" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:status]).to eq(400)
      expect(top_orders[:message]).to eq("Need a relevant quantity input.")
    end

    it 'send error based on blank param quantity' do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      invoice_3 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_4 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_5 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_6 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_7 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_8 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_9 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_10 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_11 = create(:invoice, merchant: merchant_1, status: 'pending')
      invoice_12 = create(:invoice, merchant: merchant_1, status: 'pending')

      InvoiceItem.create(invoice: invoice_1, item: item_1, quantity: 1, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_2, item: item_2, quantity: 2, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_3, item: item_3, quantity: 3, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_4, item: item_1, quantity: 4, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_5, item: item_2, quantity: 5, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_6, item: item_3, quantity: 6, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_7, item: item_1, quantity: 7, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_8, item: item_2, quantity: 8, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_9, item: item_3, quantity: 9, unit_price: item_3.unit_price)
      InvoiceItem.create(invoice: invoice_10, item: item_1, quantity: 10, unit_price: item_1.unit_price)
      InvoiceItem.create(invoice: invoice_11, item: item_2, quantity: 11, unit_price: item_2.unit_price)
      InvoiceItem.create(invoice: invoice_12, item: item_3, quantity: 12, unit_price: item_3.unit_price)

      get "/api/v1/revenue/unshipped", params: { quantity: " " }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      top_orders = JSON.parse(response.body, symbolize_names: true)

      expect(top_orders[:status]).to eq(400)
      expect(top_orders[:message]).to eq("Need a relevant quantity input.")
    end
  end
end
