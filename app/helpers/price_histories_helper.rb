module PriceHistoriesHelper
  # Returns a formatted timestamp like this:
  # Tue, October 15, 2024
  def friendly_effective_date(utc_time)
    utc_time.in_time_zone(configured_time_zone).strftime("%a, %B %d, %Y")
  end

  def configured_time_zone
    ENV.fetch("TIME_ZONE")
  end
end
