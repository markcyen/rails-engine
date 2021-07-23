require 'rails_helper'

RSpec.describe 'API Non-ReSTful' do
  describe 'find merchants with most items' do
    before :each do
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
      Transaction.destroy_all
      InvoiceItem.destroy_all
      Item.destroy_all
      Merchant.destroy_all

      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'shipped')
      create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 3)
      create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 12)
      create(:transaction, result: "success", invoice: invoice_1)
      create(:transaction, result: "failed", invoice: invoice_2)

      merchant_2 = create(:merchant)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_2)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_2)
      invoice_3 = create(:invoice, merchant: merchant_2, status: 'shipped')
      invoice_4 = create(:invoice, merchant: merchant_2, status: 'shipped')
      create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 120)
      create(:invoice_item, item: item_4, invoice: invoice_4, quantity: 76)
      create(:transaction, result: "success", invoice: invoice_3)
      create(:transaction, result: "failed", invoice: invoice_4)

      merchant_3 = create(:merchant)
      item_5 = create(:item, name: 'Tennis Racket', merchant: merchant_3)
      item_6 = create(:item, name: 'PBJ sandwich', merchant: merchant_3)
      invoice_5 = create(:invoice, merchant: merchant_3, status: 'shipped')
      invoice_6 = create(:invoice, merchant: merchant_3, status: 'shipped')
      create(:invoice_item, item: item_5, invoice: invoice_5, quantity: 5)
      create(:invoice_item, item: item_6, invoice: invoice_6, quantity: 17)
      create(:transaction, result: "success", invoice: invoice_5)
      create(:transaction, result: "failed", invoice: invoice_6)

      merchant_4 = create(:merchant)
      item_7 = create(:item, name: 'Baseball Bat', merchant: merchant_4)
      item_8 = create(:item, name: 'Kleets', merchant: merchant_4)
      invoice_7 = create(:invoice, merchant: merchant_4, status: 'shipped')
      invoice_8 = create(:invoice, merchant: merchant_4, status: 'shipped')
      create(:invoice_item, item: item_7, invoice: invoice_7, quantity: 26)
      create(:invoice_item, item: item_8, invoice: invoice_8, quantity: 7)
      create(:transaction, result: "success", invoice: invoice_7)
      create(:transaction, result: "failed", invoice: invoice_8)

      merchant_5 = create(:merchant)
      item_9 = create(:item, name: 'Basketball', merchant: merchant_5)
      item_10 = create(:item, name: 'Muffins', merchant: merchant_5)
      invoice_9 = create(:invoice, merchant: merchant_5, status: 'shipped')
      invoice_10 = create(:invoice, merchant: merchant_5, status: 'shipped')
      create(:invoice_item, item: item_9, invoice: invoice_9, quantity: 79)
      create(:invoice_item, item: item_10, invoice: invoice_10, quantity: 53)
      create(:transaction, result: "success", invoice: invoice_9)
      create(:transaction, result: "failed", invoice: invoice_10)

      merchant_6 = create(:merchant)
      item_11 = create(:item, name: 'Football', merchant: merchant_6)
      item_12 = create(:item, name: 'Muffins', merchant: merchant_6)
      invoice_11 = create(:invoice, merchant: merchant_6, status: 'shipped')
      invoice_12 = create(:invoice, merchant: merchant_6, status: 'shipped')
      create(:invoice_item, item: item_11, invoice: invoice_11, quantity: 57)
      create(:invoice_item, item: item_12, invoice: invoice_12, quantity: 39)
      create(:transaction, result: "success", invoice: invoice_11)
      create(:transaction, result: "failed", invoice: invoice_12)
    end

    it 'can send merchants with most items sold' do
      get '/api/v1/merchants/most_items', params: { quantity: 6 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:data].first[:attributes][:name]).to eq(Merchant.second.name)
      expect(merchants_most_items[:data].first[:attributes][:count]).to eq(392)
      expect(merchants_most_items[:data].last[:attributes][:name]).to eq(Merchant.first.name)
      expect(merchants_most_items[:data].last[:attributes][:count]).to eq(30)
    end

    it 'can send default top five merchants with most items sold when quantity is zero' do
      get '/api/v1/merchants/most_items', params: { quantity: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:data].first[:attributes][:name]).to eq(Merchant.second.name)
      expect(merchants_most_items[:data].first[:attributes][:count]).to eq(392)
      expect(merchants_most_items[:data].last[:attributes][:name]).to eq(Merchant.third.name)
      expect(merchants_most_items[:data].last[:attributes][:count]).to eq(44)
    end

    it 'can send default top five merchants with most items sold when no params' do
      get '/api/v1/merchants/most_items'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:data].first[:attributes][:name]).to eq(Merchant.second.name)
      expect(merchants_most_items[:data].first[:attributes][:count]).to eq(392)
      expect(merchants_most_items[:data].last[:attributes][:name]).to eq(Merchant.third.name)
      expect(merchants_most_items[:data].last[:attributes][:count]).to eq(44)
    end

    it 'can send default top five merchants with most items sold when no params' do
      get '/api/v1/merchants/most_items', params: { quantity: "" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:data].first[:attributes][:name]).to eq(Merchant.second.name)
      expect(merchants_most_items[:data].first[:attributes][:count]).to eq(392)
      expect(merchants_most_items[:data].last[:attributes][:name]).to eq(Merchant.third.name)
      expect(merchants_most_items[:data].last[:attributes][:count]).to eq(44)
    end

    it 'can send error when quantity is less than zero' do
      get '/api/v1/merchants/most_items', params: { quantity: -1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:status]).to eq(400)
      expect(merchants_most_items[:message]).to eq("Need a relevant quantity input.")
    end

    it 'can send error when quantity is less than zero' do
      get '/api/v1/merchants/most_items', params: { quantity: "hello world" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants_most_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchants_most_items[:status]).to eq(400)
      expect(merchants_most_items[:message]).to eq("Need a relevant quantity input.")
    end
  end
end
