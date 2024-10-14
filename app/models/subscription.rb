class Subscription < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.00 }

  enum :price_type, %i[ monthly annually ]

  has_many :price_histories, dependent: :destroy
  belongs_to :user

  before_save :track_price_change

  scope :sort_by_name, -> { order(name: :asc) }

  def self.currency
    ENV.fetch("CURRENCY", "").presence || "$"
  end

  def price_change_percentage
    return Float::INFINITY if initial_monthly_price.zero?

    ((monthly_price - initial_monthly_price) / initial_monthly_price.to_f * 100)
  end

  def initial_monthly_price
    (first_price_history.monthly? ? first_price_history.price : first_price_history.price / 12)
  end

  def initial_annual_price
    (first_price_history.annually? ? first_price_history.price : first_price_history.price * 12)
  end

  def first_price_history
    @earliest_price_history ||= price_histories.order(effective_date: :asc).first
  end

  def monthly_price
    (monthly? ? price : price / 12)
  end

  def annual_price
    (annually? ? price : price * 12)
  end

  def icon
    "https://www.google.com/s2/favicons?domain=#{domain}"
  end

  def domain
    # Used to fetch favicons from this URL:
    # https://www.google.com/s2/favicons?domain=#{domain}
    return unless url

    ::Addressable::URI.parse(url).host
  end

  private

  def track_price_change
    if price_changed? || price_type_changed?
      price_histories.build(
        price: price,
        price_type: price_type,
        effective_date: created_at&.to_datetime || Time.current
      )
    end
  end
end
