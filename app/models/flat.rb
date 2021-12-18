class Flat < ApplicationRecord
  belongs_to :user
  has_many :rooms
  monetize :price_cents

  after_commit :maybe_create_or_update_stripe_product_id, only: [:create,:update]

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
end
