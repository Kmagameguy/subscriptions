class CreatePriceHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :price_histories do |t|
      t.references :subscription, null: false, foreign_key: true
      t.decimal :price
      t.datetime :effective_date
      t.integer :price_type

      t.timestamps
    end
  end
end
