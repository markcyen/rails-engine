class Api::V1::ItemsController < ApplicationController

  def index
    if !params[:per_page].present? && !params[:page].present?
      items = Item.limit(20)
      render json: ItemSerializer.new(items)
    elsif params[:per_page].present? && !params[:page].present?
      if params[:per_page].to_i < 0
        render json: {status: 400, message: "Negative query results to error."}
      else
        items = Item.limit(params[:per_page].to_i)
        render json: ItemSerializer.new(items)
      end
    elsif !params[:per_page].present? && params[:page].present?
      if params[:page].to_i < 0
        render json: {status: 400, message: "Negative or zero query results to error."}
      elsif params[:page].to_i == 0
        items = Item.limit(20)
        render json: ItemSerializer.new(items)
      else
        items = Item.limit(20).offset((params[:page].to_i - 1) * 20)
        render json: ItemSerializer.new(items)
      end
    else
      if params[:per_page].present? && params[:page].present?
        if (params[:per_page].to_i < 0 && params[:page].to_i < 1) ||
          (params[:per_page].to_i < 0 && params[:page].to_i > 1) ||
          (params[:per_page].to_i > 0 && params[:page].to_i < 1)
            render json: {status: 400, message: "Negative query results to error."}
        else
          items = Item.limit(params[:per_page].to_i).offset((params[:page].to_i - 1) * params[:per_page].to_i)
          render json: ItemSerializer.new(items)
        end
      end
    end
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    created_item = Item.create(item_params)
    render json: ItemSerializer.new(created_item)
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    Item.delete(params[:id])
  end

  private
   def item_params
     params.require(:item).permit(
       :name,
       :description,
       :unit_price,
       :merchant_id
     )
   end
end
