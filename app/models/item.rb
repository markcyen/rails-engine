class Item < ApplicationRecord
  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: true
  
  belongs_to :merchant
end
