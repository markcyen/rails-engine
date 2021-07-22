require 'rails_helper'

RSpec.describe 'Items API' do
  before :all do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
    Item.destroy_all

    merchant = create(:merchant)
    63.times do |index|
      Item.create(
        name: "item_#{index + 1}",
        description: Faker::Quote.yoda,
        unit_price: Faker::Number.number(digits: 7),
        merchant: merchant
      )
    end
  end

  # after :each do
  #   FactoryBot.reload
  #   Item.destroy_all
  #   Merchant.destroy_all
  # end

  describe 'default' do
    it 'sends a list of twenty items for default query params' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an Array
      expect(items[:data].last[:attributes][:name]).to eq("item_20")
    end
  end

  describe 'default page, limit query greater than 20' do
    it 'sends a list of twenty items for default page one with limit as query param' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { per_page: 35 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)
binding.pry if items[:data].last[:attributes][:name] != "item_35"
      expect(items[:data].size).to eq(35)
      expect(items[:data].last[:attributes][:name]).to eq("item_35")
    end
  end

  describe 'default limit, page zero' do
    it 'sends a list of twenty merchants for default limit of twenty with page zero' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { page: 0 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)
binding.pry if items[:data].last[:attributes][:name] != "item_20"
      expect(items[:data].size).to eq(20)
      expect(items[:data].last[:attributes][:name]).to eq("item_20")
    end
  end

  describe 'default limit, negative page number' do
    it 'sends error message in response body' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { page: -1 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:status]).to eq(400)
      expect(items[:message]).to eq("Negative or zero query results to error.")
    end
  end

  describe 'default limit, page two' do
    it 'sends a list of twenty items for default limit of twenty with page two' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { page: 2 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)
binding.pry if items[:data].last[:attributes][:name] != "item_40"
      expect(items[:data].size).to eq(20)
      expect(items[:data].last[:attributes][:name]).to eq("item_40")
    end
  end

  describe 'limit query, default page' do
    it 'sends a list of items based on limit query and default page one' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { per_page: 39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(39)
      expect(items[:data].last[:attributes][:name]).to eq("item_39")
    end

    it 'sends error in response body when limit query is negative and default page one' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { per_page: -39 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:status]).to eq(400)
      expect(items[:message]).to eq("Negative query results to error.")
    end
  end

  describe 'both query params' do
    it 'sends list of items based on both query params' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { per_page: 15, page: 3 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(15)
      expect(items[:data].last[:attributes][:name]).to eq("item_45")
    end
  end

  describe 'query large limit' do
    it 'sends list of items based on both query params' do
      # FactoryBot.reload
      # Item.destroy_all
      # Merchant.destroy_all
      # merchant = create(:merchant)
      # 63.times do |index|
      #   Item.create(
      #     name: "item_#{index + 1}",
      #     description: Faker::Quote.yoda,
      #     unit_price: Faker::Number.number(digits: 7),
      #     merchant: merchant
      #   )
      # end

      get '/api/v1/items', params: { per_page: 100 }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].size).to eq(63)
      expect(items[:data].last[:attributes][:name]).to eq("item_63")
    end
  end
end
