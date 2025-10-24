module PriceIntervalConversion
  extend ActiveSupport::Concern

  PRICE_TYPE_INTERVALS_IN_MONTHS = {
    monthly:      1,
    quarterly:    3,
    semiannually: 6,
    annually:     12,
    biennially:   24
  }.freeze

  included do
    PRICE_TYPE_INTERVALS_IN_MONTHS.keys.each do |interval|
      define_method("#{interval}?") { price_type.to_sym == interval }
    end
  end

  def monthly_price
    price_in(:monthly)
  end

  def quarterly_price
    price_in(:quarterly)
  end

  def semiannual_price
    price_in(:semiannually)
  end

  def annual_price
    price_in(:annually)
  end

  def biennial_price
    price_in(:biennially)
  end

  protected

  def price_in(target_interval)
    target_months  = PRICE_TYPE_INTERVALS_IN_MONTHS.fetch(target_interval)
    current_months = PRICE_TYPE_INTERVALS_IN_MONTHS.fetch(price_type.to_sym)

    (price * (BigDecimal(target_months) / BigDecimal(current_months))).round(2)
  end
end
