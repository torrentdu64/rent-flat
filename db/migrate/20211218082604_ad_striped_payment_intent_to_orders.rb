class AdStripedPaymentIntentToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_payment_intent_id, :string
  end
end
