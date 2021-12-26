class Price < ApplicationRecord
  belongs_to :flat
  validate :no_more_then_three_pricing
  monetize :price_cents
  after_commit :maybe_create_or_update_stripe_price_id, only: [:create, :update]

  FREQUENCY_PAYMENT = [ 'day', 'week', 'month', 'year']

  def maybe_create_or_update_stripe_price_id
     return if !stripe_price_id.blank?
     key = self.flat.user.access_code
     Stripe.api_key = key
     price = Stripe::Price.create({
        unit_amount: self.price_cents,
        currency: self.currency,
        recurring: choose_recurrency,
        product: self.flat.stripe_product_id,
        metadata: {
          price_id: id
        }
      })
      self.update(stripe_price_id: price.id)
  end

  def choose_recurrency
     !self.recurring.blank? ?  { interval: self.recurring }  :  { interval: nil }
  end

  private

  def no_more_then_three_pricing
    self.errors.add(:base, "Max Price reatch no more") if self.flat.pricing.size > 4
  end
end
