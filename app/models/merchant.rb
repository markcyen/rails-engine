class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def revenue
    invoices.joins(:invoice_items, :transactions)
      .where('transactions.result = ? AND invoices.status = ?', "success", "shipped")
      .sum('invoice_items.quantity * invoice_items.unit_price')
      .round(2)
  end

  def self.top_revenue(quantity)
    joins(:invoices, :invoice_items, :transactions)
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where('transactions.result = ? AND invoices.status = ?', "success", "shipped")
      .group(:id)
      .order('revenue DESC')
      .limit(quantity)
  end
end
