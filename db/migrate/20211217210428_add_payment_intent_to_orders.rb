class AddPaymentIntentToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :stripe_payment_intent_id, :string
  end
end
