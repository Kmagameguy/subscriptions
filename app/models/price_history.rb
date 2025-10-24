class PriceHistory < ApplicationRecord
  include PriceIntervalConversion

  belongs_to :subscription

  enum :price_type, ::PriceTypeable::PRICE_TYPES
end
