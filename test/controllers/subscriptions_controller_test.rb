require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  before do
    @valid_password = "secure_password"
    @user = User.create!(name: "John Doe", password: @valid_password, password_confirmation: @valid_password)
    @subscription = Subscription.create!(
      name: "My Subscription",
      url: "https://www.example.com",
      price_type: Subscription.price_types[:monthly],
      price: 19.99.to_d,
      user: @user
    )

    post user_sessions_url(user: { name: @user.name, password: @valid_password, password_confirmation: @valid_password })
  end

  describe "#index" do
    it "can show the index page" do
      get subscriptions_url

      assert_response :success
    end
  end

  describe "#show" do
    it "can show an individual subscription" do
      get subscription_url(@subscription)

      assert_response :success
      assert_select "h1", @subscription.name
    end
  end

  describe "#new" do
    it "can create a new record" do
      get new_subscription_url

      assert_response :success
      assert_select "h1", "New Subscription"
    end
  end

  describe "#create" do
    it "creates a new subscription" do
      params = { subscription: { name: "My Cool Subscription", price: 10.99, user: @user } }
      post subscriptions_url(params)

      assert_equal "Subscription created!", flash[:info]
      assert_redirected_to subscriptions_url
    end
  end

  describe "#edit" do
    it "can open an existing subscription for editing" do
      get edit_subscription_url(@subscription)

      assert_response :success
      assert_select "h1", "Edit Subscription"
    end
  end

  describe "#update" do
    it "updates a subscription" do
      params = { subscription: { name: "My Fixed Subscription" } }
      patch subscription_url(@subscription), params: params

      assert_equal "Subscription Updated", flash[:info]
      assert_equal "My Fixed Subscription", @subscription.reload.name
      assert_redirected_to subscriptions_url
    end
  end

  describe "#destroy" do
    it "deletes a subscription" do
      assert_difference("Subscription.count", -1) do
        delete subscription_url(@subscription)
      end

      assert_equal "Subscription Removed", flash[:info]
      assert_redirected_to subscriptions_url
    end
  end
end
