class AddStripeProductIdTFlats < ActiveRecord::Migration[6.1]
  def change
    add_column :flats, :stripe_product_id, :string
  end
end
