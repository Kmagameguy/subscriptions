class SubscriptionsController < ApplicationController
  before_action :find_subscription, only: %i[ show edit update destroy ]
  def index
    @subscriptions = Subscription.all
  end

  def show; end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      flash[:info] = "Subscription created!"
      redirect_to subscriptions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subscription.update(subscription_params)
      flash[:info] = "Subscription Updated"
      redirect_to subscriptions_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy
    flash[:info] = "Subscription Removed"
    redirect_to subscriptions_path
  end

  private

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:name, :url, :price_type, :price)
  end
end
