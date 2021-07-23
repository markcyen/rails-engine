class Api::V1::Revenue::UnshippedController < ApplicationController
  CONSTANT = 10

  def index
    if params[:quantity].to_i < 0 ||
      params[:quantity] == '' ||
      !params[:quantity].to_s.scan(/\D/).empty? ||
      Invoice.unshipped_potential(params[:quantity]).nil?
        render json: {data: {}, status: 400, message: 'Need a relevant quantity input.'}
    elsif !params[:quantity].present? ||
      params[:quantity].nil? ||
      params[:quantity].empty? ||
      params[:quantity].to_i == 0
        invoices = Invoice.unshipped_potential(CONSTANT)
        render json: UnshippedSerializer.new(invoices)
    else
      invoices = Invoice.unshipped_potential(params[:quantity].to_i)
      render json: UnshippedSerializer.new(invoices)
    end
  end
end
