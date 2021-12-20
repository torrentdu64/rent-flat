class StripeProductCreated
  def call(event)
      flat = Flat.find_by(stripe_product_id: event.data.object.id)
      flat.update(status: 'validated')
  end
end
