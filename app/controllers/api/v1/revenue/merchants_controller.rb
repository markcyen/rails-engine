class Api::V1::Revenue::MerchantsController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    # binding.pry
    # merchant_revenue = merchant.revenue.round(2)
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
