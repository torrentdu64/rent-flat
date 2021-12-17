class AddPriceToFlats < ActiveRecord::Migration[6.1]
  def change
    add_monetize :flats, :price, currency: { present: false }
  end
end
