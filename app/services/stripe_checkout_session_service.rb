class StripeCheckoutSessionService
  def call(event)
    order = Order.find_by(checkout_session_id: event.data.object.id)
    p event.to_json
    order.update(state: 'paid', stripe_payment_intent_id: event.data.object.payment_intent)
  end
end
