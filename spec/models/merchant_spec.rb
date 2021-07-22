require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe '#revenue' do
    it 'calculates revenue for a given merchant' do
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

      expect(merchant_1.revenue.round(2)).to eq(12599.40)
    end

    describe '#top_revenue' do
      it 'calculates top revenue of merchants' do
        merchant_1 = create(:merchant)
        item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
        item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
        item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
        invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
        invoice_2 = create(:invoice, merchant: merchant_1, status: 'shipped')
        create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 10, unit_price: item_1.unit_price)
        create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 15, unit_price: item_2.unit_price)
        create(:invoice_item, item: item_3, invoice: invoice_1, quantity: 20, unit_price: item_3.unit_price)
        create(:transaction, result: "success", invoice: invoice_1)
        create(:transaction, result: "success", invoice: invoice_2)

        merchant_2 = create(:merchant)
        item_4 = create(:item, unit_price: 129.52, merchant: merchant_2)
        invoice_3 = create(:invoice, merchant: merchant_2, status: 'shipped')
        create(:invoice_item, item: item_4, invoice: invoice_3, quantity: 7, unit_price: item_4.unit_price)
        create(:transaction, result: "success", invoice: invoice_3)

        quantity = 10

        expect(Merchant.top_revenue(quantity).first.revenue.round(2)).to eq(19310.80)
        expect(Merchant.top_revenue(quantity).second.revenue.round(2)).to eq(906.64)
        expect(Merchant.top_revenue(quantity).third).to eq(nil)
      end
    end

    describe '::search' do
      it 'can search for merchant by name' do
        merchant_1 = Merchant.create(name: 'Turing')
        merchant_2 = Merchant.create(name: 'Ring World')
        merchant_3 = Merchant.create(name: 'Turnstyle Palace')

        expect(Merchant.search('ring').first).to eq(merchant_1)
      end
    end
  end
end
