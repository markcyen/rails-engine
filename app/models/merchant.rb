class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items, dependent: :destroy

  def self.limit_merchants_per_page(data_limit = 20, page = 1)
    # binding.pry
    if data_limit.to_i > 20 && page.to_i <= 1
      limit(DATA_LIMIT)
    elsif page.to_i < 1
      limit(DATA_LIMIT)
    else
      limit(data_limit.to_i).offset(
        (page.to_i - 1) * data_limit.to_i
      )
    end
  end
end
