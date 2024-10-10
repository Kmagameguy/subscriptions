class Subscription < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.00 }

  enum :price_type, %i[ monthly annually ]

  scope :sort_by_name, -> { order(name: :asc) }

  def monthly_price
    (monthly? ? price : price / 12)
  end

  def annual_price
    (annually? ? price : price * 12)
  end

  def domain
    # Used to fetch favicons from this URL:
    # https://www.google.com/s2/favicons?domain=#{domain}
    return unless url

    ::Addressable::URI.parse(url).host
  end
end
