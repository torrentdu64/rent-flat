class OrdersController < ApplicationController

  def create
    flat = Flat.find(params[:flat_id])
    order  = Order.create!(flat: flat, flat_sku: flat.title, amount: flat.price, state: 'pending', user: current_user)

    checkout_session = Stripe::Checkout::Session.create(
      success_url: order_url(order),
      cancel_url: order_url(order),
      customer: current_user.stripe_customer_id,
      mode: 'payment',
      line_items: [{
        price_data: {
          unit_amount: flat.price_cents,
          currency: 'nzd',
          product: flat.stripe_product_id
        },
        quantity: 1,
      }],
      metadata: {
        order_id: order.id,
      },
      payment_intent_data: {
        metadata: {
          order_id: order.id,
        },
      }
    )


    order.update(checkout_session_id: checkout_session.id)
    redirect_to new_order_payment_path(order)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
