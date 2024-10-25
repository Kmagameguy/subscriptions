class AddSubscribedOnDateToSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :subscribed_on, :date
  end
end
