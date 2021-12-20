class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :stripe_price_id
      t.string :currency
      t.boolean :active
      t.string :metadata
      t.string :stripe_product_id
      t.string :nickname
      t.json :recurring
      t.monetize :price, currency: { present: false }
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
