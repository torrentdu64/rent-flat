class AddRefundIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :stripe_refund_id, :string
  end
end
