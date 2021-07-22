class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.unshipped_potential(quantity)
    joins(:invoice_items)
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) AS potential_revenue')
      .where.not('invoices.status = ?', "shipped")
      .where.not('invoices.status = ?', "returned")
      .group(:id)
      .order('potential_revenue DESC')
      .limit(quantity)
  end
end
