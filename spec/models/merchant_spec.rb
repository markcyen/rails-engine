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

    describe '::find_most_items' do
      before :each do
        ActiveRecord::Base.connection.tables.each do |t|
          ActiveRecord::Base.connection.reset_pk_sequence!(t)
        end
        Transaction.destroy_all
        InvoiceItem.destroy_all
        Item.destroy_all
        Merchant.destroy_all
      end

      it 'can find merchants with most items' do
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

        expect(Merchant.find_most_items(6).first).to eq(merchant_2)
        expect(Merchant.find_most_items(6).second).to eq(merchant_5)
      end
    end
  end
end
