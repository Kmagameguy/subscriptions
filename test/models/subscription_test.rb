require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  before do
    @valid_password = "secure_password"
    @user = User.create!(name: "John Doe", password: @valid_password, password_confirmation: @valid_password)
    @subscription = Subscription.new(
      name: "My Subscription",
      price_type: Subscription.price_types[:monthly],
      price: 10.55.to_d,
      user: @user
    )
  end

  describe ".currency" do
    it "reports the user specified currency" do
      ENV["CURRENCY"] = "€"

      assert_equal "€", Subscription.currency
    end

    it "uses the American Dollar as a default when no currency is specified" do
      ENV["CURRENCY"] = nil

      assert_equal "$", Subscription.currency
    end
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

  describe "#sort_by_name" do
    it "sorts all subscription records alphabetically, by name, in ascending order" do
      @user.subscriptions.create!(name: "Netflix", price: 19.99)
      @user.subscriptions.create!(name: "Max", price: 20.00)
      @user.subscriptions.create!(name: "A Service", price: 1.00)

      assert_equal Subscription.sort_by_name.first.name, "A Service"
    end
  end

  describe "#monthly_price" do
    it "returns the database value if it's a monthly subscription" do
      assert_equal @subscription.price, @subscription.monthly_price
    end

    it "divides the value by 12 if it's an annual subscription" do
      @subscription.price_type = Subscription.price_types[:annually]
      @subscription.price = 12.to_d

      assert_equal 1.00, @subscription.monthly_price
    end
  end

  describe "#annual_price" do
    it "returns the database value if it's an annual subscription" do
      @subscription.price_type = Subscription.price_types[:annually]

      assert_equal @subscription.price, @subscription.annual_price
    end

    it "multiplies the value by 12 if it's a monthly subscription" do
      @subscription.price = 1.00.to_d

      assert_equal (@subscription.price * 12), @subscription.annual_price
    end
  end

  describe "#domain" do
    it "extracts the domain from a url" do
      @subscription.url = "https://www.example.com/some_path/another_path?with_query=\"test\""

      assert_equal "www.example.com", @subscription.domain
    end

    it "returns nil if the url is not specified" do
      assert_nil @subscription.domain
    end
  end
end
