require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    [:name, :description, :unit_price].each do |attribute|
      it {should validate_presence_of(attribute)}
    end

    it {should validate_numericality_of :unit_price}
    it {should belong_to :merchant}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe '::search' do
    it 'can search for merchant by name' do
      merchant_1 = create(:merchant)
      item_1 = create(:item, name: 'Ice cream', merchant: merchant_1)
      item_2 = create(:item, name: 'Chocolate cake', merchant: merchant_1)
      item_3 = create(:item, name: 'Cream cheese', merchant: merchant_1)
      item_4 = create(:item, name: 'Strawberry cream cheese', merchant: merchant_1)

      expect(Item.search('cream').first).to eq(item_1)
      expect(Item.search('cream').second).to eq(item_4)
      expect(Item.search('Cream').first).to eq(item_3)
      expect(Item.search('stew')).to eq([])
    end
  end
end
