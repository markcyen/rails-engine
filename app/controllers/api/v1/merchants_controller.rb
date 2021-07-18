class Api::V1::MerchantsController < ApplicationController
  DATA_LIMIT = 20
  PAGE_DEFAULT = 1

  def index
    # page = params.fetch(:page, 0).to_i
# binding.pry
    if !params[:data_limit].present? && !params[:page].present?
      render json: Merchant.limit_merchants_per_page
    elsif params[:data_limit].present? && !params[:page].present?
      if params[:data_limit].to_i < 0
        render json: Merchant.limit_merchants_per_page
      else
        render json: Merchant.limit_merchants_per_page(params[:data_limit], PAGE_DEFAULT)
      end
    elsif !params[:data_limit].present? && params[:page].present?
      if params[:page].to_i <= 0
        render json: Merchant.limit_merchants_per_page
      else
        render json: Merchant.limit_merchants_per_page(DATA_LIMIT, params[:page])
      end
    else
      if params[:data_limit].to_i < 0
        render json: Merchant.limit_merchants_per_page(DATA_LIMIT, params[:page])
      elsif params[:data_limit].to_i < DATA_LIMIT
        render json: Merchant.limit_merchants_per_page(params[:data_limit].to_i % DATA_LIMIT)
      elsif params[:page].to_i <= 0
        render json: Merchant.limit_merchants_per_page(params[:data_limit])
      else
        render json: Merchant.limit_merchants_per_page(params[:data_limit], params[:page])
      end
    end
  end

  def show
    render json: Merchant.find(params[:id])
  end

end
