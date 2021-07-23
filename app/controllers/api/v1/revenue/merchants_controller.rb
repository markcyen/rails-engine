class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    # binding.pry
    if !params[:quantity].present? ||
      params[:quantity].nil? ||
      params[:quantity].empty? ||
      params[:quantity].to_i < 1 ||
      params[:quantity] == '' ||
      !params[:quantity].to_s.scan(/\D/).empty?
        render json: {status: 400, message: 'Need a relevant quantity input.'}
    else
      render json: MostRevenueSerializer.new(Merchant.top_revenue(params[:quantity]))
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
