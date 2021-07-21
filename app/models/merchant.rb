class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  def revenue
    invoices.joins(:invoice_items, :transactions)
      # .group(':id', 'invoices.id')
      .where('transactions.result = ? AND invoices.status = ?', "success", "shipped")
      .sum('invoice_items.quantity * invoice_items.unit_price')
      .round(2)
  end
end
