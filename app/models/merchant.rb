class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items, dependent: :destroy

  def self.limit_merchants_per_page(data_limit = 20, page = 1)
    limit(data_limit.to_i).offset(
      (page.to_i - 1) * data_limit.to_i
    )
  end
end
