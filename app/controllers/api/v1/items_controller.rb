class Api::V1::ItemsController < ApplicationController

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    render json: Item.create(item_params)
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    render json: Item.delete(params[:id])
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
