class Api::V1::MerchantsController < ApplicationController
  CONSTANT = 5
  def index
    if !params[:per_page].present? && !params[:page].present?
      merchants = Merchant.limit(20)
      render json: MerchantSerializer.new(merchants)
    elsif params[:per_page].present? && !params[:page].present?
      if params[:per_page].to_i < 0
        render json: {status: 400, message: "Negative query results to error."}
      else
        merchants = Merchant.limit(params[:per_page].to_i)
        render json: MerchantSerializer.new(merchants)
      end
    elsif !params[:per_page].present? && params[:page].present?
      if params[:page].to_i < 0
        render json: {status: 400, message: 'Negative or zero query results to error.'}
      elsif params[:page].to_i == 0
        merchants = Merchant.limit(20)
        render json: MerchantSerializer.new(merchants)
      else
        merchants = Merchant.limit(20).offset((params[:page].to_i - 1) * 20)
        render json: MerchantSerializer.new(merchants)
      end
    else
      if params[:per_page].present? && params[:page].present?
        if (params[:per_page].to_i < 0 && params[:page].to_i < 1) ||
          (params[:per_page].to_i < 0 && params[:page].to_i > 1) ||
          (params[:per_page].to_i > 0 && params[:page].to_i < 1)
            render json: {status: 400, message: "Negative query results to error."}
        else
          merchants = Merchant.limit(params[:per_page].to_i).offset((params[:page].to_i - 1) * params[:per_page].to_i)
          render json: MerchantSerializer.new(merchants)
        end
      end
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find
    if params[:name].nil? ||
      !params[:name].present? ||
      params[:name].empty? ||
      Merchant.search(params[:name]).empty?
        render json: {data: {}, status: 400, message: 'No required query name input.'}
    else
      find_merchant = Merchant.search(params[:name]).first
      render json: MerchantSerializer.new(find_merchant)
    end
  end

  def most_items
    if params[:quantity].to_i < 0 ||
      !params[:quantity].to_s.scan(/\D/).empty?
        render json: {status: 400, message: 'Need a relevant quantity input.'}
    elsif !params[:quantity].present? ||
      params[:quantity].nil? ||
      params[:quantity].empty? ||
      params[:quantity].to_i == 0 ||
      params[:quantity] == ''
        merchants_with_most_items = Merchant.find_most_items(CONSTANT)
        render json: MostItemsSerializer.new(merchants_with_most_items)
    else
      merchants_with_most_items = Merchant.find_most_items(params[:quantity])
      render json: MostItemsSerializer.new(merchants_with_most_items)
    end
  end
end
