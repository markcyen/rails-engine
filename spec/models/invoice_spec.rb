require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it {should validate_presence_of :status}
  end

  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
  end

  describe '.unshipped_potential' do
    it 'calculates potential revenue from unshipped invoice orders' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, unit_price: 294.93, merchant: merchant_1)
      item_2 = create(:item, unit_price: 643.34, merchant: merchant_1)
      item_3 = create(:item, unit_price: 335.57, merchant: merchant_1)
      invoice_1 = create(:invoice, merchant: merchant_1, status: 'shipped')
      invoice_2 = create(:invoice, merchant: merchant_1, status: 'packaged')
      create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 10, unit_price: item_1.unit_price)
      create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 15, unit_price: item_2.unit_price)
      create(:invoice_item, item: item_3, invoice: invoice_2, quantity: 20, unit_price: item_3.unit_price)
      create(:transaction, result: "success", invoice: invoice_1)
      create(:transaction, result: "success", invoice: invoice_2)

      merchant_2 = create(:merchant)
      item_4 = create(:item, unit_price: 129.52, merchant: merchant_2)
      invoice_3 = create(:invoice, merchant: merchant_2, status: 'pending')
      create(:invoice_item, item: item_4, invoice: invoice_3, quantity: 7, unit_price: item_4.unit_price)
      create(:transaction, result: "success", invoice: invoice_3)

      quantity = 7

      expect(Invoice.unshipped_potential(quantity).first.potential_revenue.round(2)).to eq(6711.40)
      expect(Invoice.unshipped_potential(quantity).second.potential_revenue.round(2)).to eq(906.64)
    end
  end
end
