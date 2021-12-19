class Flat < ApplicationRecord
  belongs_to :user
  has_many :rooms
  monetize :price_cents

  after_commit :maybe_create_or_update_stripe_product_id, only: [:create,:update]
  after_commit :maybe_create_or_update_stripe_price_id, only: [:create, :update]


  def to_builder
    Jbuilder.new do |flat|
      flat.price stripe_price_id
      flat.quantity 1
    end
  end

  def maybe_create_or_update_stripe_product_id
      return if !stripe_product_id.blank?
      product = Stripe::Product.create(
        name: title,
        url: Rails.application.routes.url_helpers.url_for(self),
        metadata: {
          flat_id: id
        }
      )
      self.update(stripe_product_id: product.id)

  end

  def maybe_create_or_update_stripe_price_id
    return if !stripe_price_id.blank?
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
