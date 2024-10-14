class AddUsersToSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_reference :subscriptions, :user, null: false, foreign_key: true
  end
end
