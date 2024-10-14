class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(name: params[:user][:name])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      flash[:info] = "You have logged in"
      redirect_to root_path
    else
      flash[:alert] = "Login failed"
      redirect_to new_user_sessions_url
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You have logged out"
    redirect_to root_path
  end
end
