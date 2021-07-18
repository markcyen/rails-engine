class Api::V1::MerchantsController < ApplicationController

  def index
    # page = params.fetch(:page.0).to_i
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end

end
