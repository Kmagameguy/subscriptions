class PriceHistory < ApplicationRecord
  include PriceIntervalConversion

  belongs_to :subscription

  enum :price_type, %i[ monthly annually quarterly semiannually biennially ]
end
