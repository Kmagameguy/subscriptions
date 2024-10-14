require "test_helper"

class UserTest < ActiveSupport::TestCase
  before do
    @valid_password = "secure_password"
    @user = User.new(name: "John Doe", password: @valid_password, password_confirmation: @valid_password)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      _(@user).must_be :valid?
    end

    it "must have a name" do
      @user.name = nil

      _(@user).must_be :invalid?
      _(@user.errors[:name]).must_include "can't be blank"
    end

    it "must have a matching password confirmation" do
      @user.password_confirmation = "not-a-match"

      _(@user).must_be :invalid?
      _(@user.errors[:password_confirmation]).must_include "doesn't match Password"
    end
  end

  describe "associations" do
    before { @user.save! }

    it "can have many subscriptions" do
      subscription = Subscription.new(name: "Sub", url: "https://www.example.com", price_type: Subscription.price_types[:monthly], price: "1.00", user: @user)

      assert_respond_to @user, :subscriptions
      assert_equal subscription.user, @user
    end
  end

  describe "password authentication" do
    before { @user.save! }

    it "will authenticate with a valid password" do
      authenticated_user = User.find_by(name: @user.name).authenticate(@valid_password)

      assert_equal authenticated_user, @user
    end

    it "will not authenticate with an invalid password" do
      unauthenticated_user = User.find_by(name: @user.name).authenticate("wrong-password")

      assert_not unauthenticated_user
    end
  end
end
