require 'rails_helper'

describe 'Merchants API' do
  before :each do
    create_list(:merchant, 25)
  end
  it 'sends a list of twenty merchants for default query params' do
    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.size).to eq(20)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'sends a list of twenty merchants for default page one with limit as query param' do
    get '/api/v1/merchants', params: { data_limit: 35 }

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.size).to eq(20)
    expect(merchants.last[:id]).to eq(20)
  end

  it 'sends a list of twenty merchants for default limit of twenty with page zero' do
    get '/api/v1/merchants', params: { page: 0 }

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.size).to eq(20)
    expect(merchants.last[:id]).to eq(20)
  end
end
