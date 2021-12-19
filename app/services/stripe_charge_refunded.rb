class StripeChargeRefunded
  def call(event)
    order = Order.find_by(stripe_payment_intent_id: event.data.object.payment_intent)
    order.update(state: 'cancel')
  end
end
