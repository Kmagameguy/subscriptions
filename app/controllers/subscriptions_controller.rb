class SubscriptionsController < ApplicationController
  before_action :find_subscription, only: %i[ show edit update destroy ]
  def index
    if current_user.blank?
      @subscriptions = Subscription.none
    else
      @subscriptions = current_user.subscriptions.sort_by_name
    end
  end

  def show; end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params.merge(user: current_user))

    if @subscription.save
      flash[:info] = "Subscription created!"
      respond_to do |format|
        format.html { redirect_to subscriptions_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subscription.update(subscription_params.merge(user: current_user))
      flash[:info] = "Subscription Updated"
      redirect_to subscriptions_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription.destroy

    flash[:info] = "Subscription Removed"
    respond_to do |format|
      format.html { redirect_to subscriptions_path }
      format.turbo_stream
    end
  end

  private

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:name, :url, :price_type, :price, :subscribed_on)
  end
end
