class Subscription < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true

  enum :price_type, %i[ monthly annually ]

  def monthly_price
    (monthly? ? price : price / 12)
  end
end
