class Api::V1::MerchantsController < ApplicationController

  def index
    page = params.fetch(:page, 0).to_i

    if !params[:data_limit].present? || !params[:page].present?
      render json: Merchant.all.limit_merchants_per_page
    elsif params[:data_limit].present?
      render json: Merchant.all.limit_merchants_per_page(params[:data_limit])
    elsif params[:page].present?
      render json: Merchant.all.limit_merchants_per_page(params[:page])
    else
      render json: Merchant.all.limit_merchants_per_page(params[:data_limit], params[:page])
    end
  end

  def show
    render json: Merchant.find(params[:id])
  end

end
