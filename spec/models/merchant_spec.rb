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

      expect(merchant_1.revenue).to eq(12599.40)
    end
  end
end
