class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates :unit_price, numericality: true

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  belongs_to :merchant

  def self.search(search_params)
    where("name LIKE ?", "%#{search_params}%")
  end
end
