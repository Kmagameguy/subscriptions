class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.string :name, null: false
      t.string :url
      t.integer :price_type, default: 0
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
