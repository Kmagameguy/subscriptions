module SubscriptionsHelper
  def total_monthly
    current_user.subscriptions.sum(&:monthly_price)
  end

  def total_annually
    current_user.subscriptions.sum(&:annual_price)
  end

  def percentage_increase_text(subscription)
    span_class = "no-price-change"
    text = "No price changes"

    if subscription.price_change_percentage > 0.00
      span_class = "moderate-price-change"
      text = "Price increased #{number_to_percentage subscription.price_change_percentage, precision: 0}"
    end

    if subscription.price_change_percentage >= 50.00
      span_class = "large-price-change"
      text += "!"
    end

    if subscription.price_change_percentage >= 100.00
      span_class = "absurd-price-change"
    end

    "<span class=\"#{span_class}\">#{text}</span>".html_safe
  end
end
