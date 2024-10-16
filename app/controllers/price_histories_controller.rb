class PriceHistoriesController < ApplicationController
  def show
    @price_history = PriceHistory.includes(:subscription).where(subscription_id: params[:subscription_id])
  end
end
