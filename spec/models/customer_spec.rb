require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    [:first_name, :last_name].each do |attribute|
      it {should validate_presence_of(attribute)}
    end
  end

  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many(:transactions).through(:invoices)}
  end
end
