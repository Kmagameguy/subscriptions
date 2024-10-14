module SubscriptionsHelper
  def total_monthly
    current_user.subscriptions.sum(&:monthly_price)
  end

  def total_annually
    current_user.subscriptions.sum(&:annual_price)
  end
end
