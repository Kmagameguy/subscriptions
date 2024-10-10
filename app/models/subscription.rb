class Subscription < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.00 }

  enum :price_type, %i[ monthly annually ]

  def monthly_price
    (monthly? ? price : price / 12)
  end
end
