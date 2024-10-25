class Subscription < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.00 }
  validate  :subscribed_on_cannot_be_in_future

  enum :price_type, %i[ monthly annually ]

  has_many :price_histories, dependent: :destroy
  belongs_to :user

  before_save :track_price_change

  scope :sort_by_name, -> { order(name: :asc) }

  def self.currency
    ENV.fetch("CURRENCY", "").presence || "$"
  end

  def renews_this_week?
    return false unless subscribed_on.present?

    (renews_on - Date.current).to_i <= 7
  end

  def renews_on
    return unless subscribed_on.present?

    current_date = Date.current
    next_renewal = nil

    if monthly?
      next_renewal = subscribed_on.next_month

      while next_renewal < current_date
        next_renewal = next_renewal.next_month
      end
    else
      next_renewal = subscribed_on.next_year

      while next_renewal < current_date
        next_renewal = next_renewal.next_year
      end
    end

    next_renewal
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

  def subscribed_on_cannot_be_in_future
    if subscribed_on.present? && subscribed_on > Date.current
        errors.add(:subscribed_on, "cannot be in the future")
    end
  end

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
