class OrdersController < ApplicationController

  def create
    flat = Flat.find(params[:flat_id])
    order  = Order.create!(flat: flat, flat_sku: flat.title, amount: flat.price, state: 'pending', user: current_user)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: flat.title,
        amount: flat.price_cents,
        currency: 'nzd',
        quantity: 1
      }],
      success_url: order_url(order),
      cancel_url: order_url(order)
    )

    order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(order)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
