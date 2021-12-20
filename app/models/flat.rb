class Flat < ApplicationRecord
  belongs_to :user
  has_many :rooms
  has_many :prices
  monetize :price_cents

  after_commit :maybe_create_or_update_stripe_product_id, only: [:create,:update]
  #after_commit :maybe_create_or_update_stripe_price_id, only: [:create, :update]
  #after_commit :save_stripe_plan, only: [:create_plan]

  attr_accessor :currency, :nickname, :recurring

  def to_builders
    Jbuilder.new do |flat|
      flat.price stripe_price_id
      flat.quantity 1
    end
  end

  def maybe_create_or_update_stripe_product_id
      return if !stripe_product_id.blank?
      key = self.user.access_code
      Stripe.api_key = key
      product = Stripe::Product.create(
        {
        name: title,
        url: Rails.application.routes.url_helpers.url_for(self),
        metadata: {
          flat_id: id
        }
      })
      self.update(stripe_product_id: product.id)

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

  def save_stripe_plan
     key = self.user.access_code
      Stripe.api_key = key
      plan = Stripe::Plan.create({
        id: "flat_#{self.id}",
        amount: self.price_cents,
        currency: 'nzd',
        interval: 'month',
        product: { name: self.title },
        nickname: self.title.parameterize
      })
      self.update(stripe_plan_id: plan.id)
  end

  def maybe_create_or_update_stripe_price_id

  end
end
