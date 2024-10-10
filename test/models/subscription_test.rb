require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  before do
    @subscription = Subscription.new(
      name: "My Subscription",
      price_type: Subscription.price_types[:monthly],
      price: 10.55.to_d
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      _(@subscription).must_be :valid?
    end

    it "must have a name" do
      @subscription.name = nil

      _(@subscription).must_be :invalid?
      _(@subscription.errors[:name]).must_include "can't be blank"
    end

    it "must have a price" do
      @subscription.price = nil

      _(@subscription).must_be :invalid?
      _(@subscription.errors[:price]).must_include "can't be blank"
    end

    it "must have a decimal price value" do
      @subscription.price = "not a number"

      _(@subscription).must_be :invalid?
      _(@subscription.errors[:price]).must_include "is not a number"
    end

    it "must have a non-negative price" do
      @subscription.price = -1.00

      _(@subscription).must_be :invalid?
      _(@subscription.errors[:price]).must_include "must be greater than or equal to 0.0"
    end
  end

  describe "#price_type" do
    it "uses monthly as the default value" do
      subscription = Subscription.new(name: "My Second Subscription", price: 1.00)

      assert subscription.monthly?
    end

    it "accepts an annual value" do
      @subscription.price_type = Subscription.price_types[:annually]

      assert @subscription.annually?
    end
  end

  describe "#monthly_price" do
    it "returns the database value if it's a monthly subscription" do
      assert_equal 10.55.to_d, @subscription.monthly_price
    end

    it "divides the value by 12 if it's an annual subscription" do
      @subscription.price_type = Subscription.price_types[:annually]
      @subscription.price = 12.to_d

      assert_equal 1.00, @subscription.monthly_price
    end
  end
end
