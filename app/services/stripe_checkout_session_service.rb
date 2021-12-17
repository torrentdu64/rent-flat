class StripeCheckoutSessionService
  def call(event)
    p Order.find_by(checkout_session_id: event.data.object.id)
    order = Order.find_by(checkout_session_id: event.data.object.id)
    p order
    order.update(state: 'paid')
  end
end
