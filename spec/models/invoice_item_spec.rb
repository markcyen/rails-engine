require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    [:quantity, :unit_price].each do |attribute|
      it {should validate_presence_of(attribute)}
    end

    [:quantity, :unit_price].each do |attribute|
      it {should validate_numericality_of(attribute)}
    end
  end
end
