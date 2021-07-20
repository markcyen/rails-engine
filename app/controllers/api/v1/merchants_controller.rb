class Api::V1::MerchantsController < ApplicationController
  DATA_LIMIT = 20
  PAGE_DEFAULT = 1

  def index
    if !params[:data_limit].present? && !params[:page].present?
      render json: Merchant.limit(20)
    elsif params[:data_limit].present? && !params[:page].present?
      if params[:data_limit].to_i < 0
        render json: {status: 400, message: "Negative query results to error."}
      else
        render json: Merchant.limit(params[:data_limit].to_i)
      end
    elsif !params[:data_limit].present? && params[:page].present?
      if params[:page].to_i < 0
        render json: {status: 400, message: "Negative or zero query results to error."}
      elsif params[:page].to_i == 0
        render json: Merchant.limit(20)
      else
        render json: Merchant.limit(20).offset((params[:page].to_i - 1) * 20)
      end
    else
      if params[:data_limit].present? && params[:page].present?
        if (params[:data_limit].to_i < 0 && params[:page].to_i < 1) ||
          (params[:data_limit].to_i < 0 && params[:page].to_i > 1) ||
          (params[:data_limit].to_i > 0 && params[:page].to_i < 1)
            render json: {status: 400, message: "Negative query results to error."}
        else
          render json: Merchant.limit(params[:data_limit].to_i).offset((params[:page].to_i - 1) * params[:data_limit].to_i)
        end
      end
    end

#     if !params[:page].present?
#       page = 1
#     elsif params[:page].present?
#       if params[:page].to_i < 1
#         page = 1
#       else
#         page = params[:page].to_i
#       end
#     end
# # binding.pry

#
#     if params[:data_limit].present? && !params[:page].present?
#       if params[:data_limit].to_i < 0
#         render json: {status: 400, message: "Negative query results to error."}
#       elsif params[:data_limit].to_i > 20
#         render json: Merchant.limit(20)
#       else
#         render json: Merchant.limit(params[:data_limit].to_i)
#       end
#     end
#
#     if !params[:data_limit].present? && params[:page].present?
#       # if params[:page].to_i < 1
#       #   render json: {status: 400, message: "Negative or zero query results to error."}
#       # else
#         render json: Merchant.limit(20).offset((page - 1) * 20)
#       # end
#     end
#
#     if params[:data_limit].present? && params[:page].present?
#       if (params[:data_limit].to_i < 0 && params[:page].to_i < 1) ||
#         (params[:data_limit].to_i < 0 && params[:page].to_i > 1) ||
#         (params[:data_limit].to_i > 0 && params[:page].to_i < 1)
#           render json: {status: 400, message: "Negative query results to error."}
#       else
#         render json: Merchant.limit(params[:data_limit].to_i).offset((page - 1) * params[:data_limit].to_i)
#       end
#     end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

end
