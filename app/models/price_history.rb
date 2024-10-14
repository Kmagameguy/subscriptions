class PriceHistory < ApplicationRecord
  belongs_to :subscription

  enum :price_type, %i[ monthly annually ]
end
