require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { name: "John Doe", password: "secure_password", password_confirmation: "secure_password" }
    @user = User.create!(@user_params.merge(id: 1))
  end

  describe "#new" do
    it "should render a new session form" do
      get new_user_sessions_url

      assert_response :success
      assert_select "h1", "Login"
    end
  end

  describe "#create" do
    it "should authenticate a user with the proper credentials" do
      post user_sessions_url(user: @user_params)

      assert_redirected_to root_url
      assert_equal flash[:info], "You have logged in"
    end

    it "should not authenticate a user with improper credentials" do
      post user_sessions_url(user: @user_params.merge(name: ""))

      assert_redirected_to new_user_sessions_url
      assert_equal flash[:alert], "Login failed"
    end
  end

  describe "#destroy" do
    before { post user_sessions_url(user: @user_params) }
    it "should destroy the session and log out the user" do
      assert_not_nil session[:user_id]
      delete user_sessions_url

      assert_nil session[:user_id]
      assert_equal flash[:info], "You have logged out"
      assert_redirected_to root_url
    end
  end
end
