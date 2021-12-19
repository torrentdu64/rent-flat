class AddStripePriceIdToFlats < ActiveRecord::Migration[6.1]
  def change
    add_column :flats, :stripe_price_id, :string
  end
end
