class Price < ApplicationRecord
  belongs_to :flat
  monetize :price_cents

  after_commit :maybe_create_or_update_stripe_price_id, only: [:create, :update]


  def maybe_create_or_update_stripe_price_id
       return if !stripe_price_id.blank?
       key = self.user.access_code
      Stripe.api_key = key
      price = Stripe::Price.create({
        unit_amount: self.price_cents,
        currency: 'nzd',
        #recurring: {interval: 'month'},
        product: self.stripe_product_id,
        metadata: {
          flat_id: id
        }
      })
      self.update(stripe_price_id: price.id)
  end
end
