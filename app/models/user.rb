class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable , omniauth_providers: [:stripe_connect]

  after_commit :maybe_create_or_update_stripe_customer_id, on: [:create, :update]

  has_many :rents
  has_many :flats
  has_many :orders

  def maybe_create_or_update_stripe_customer_id
      return if !stripe_customer_id.blank?
      customer = Stripe::Customer.create(
        email: email,
        metadata: {
          user_id: id
        }
      )

      byebug
      self.update(stripe_customer_id: customer.id)
  end

  def can_receive_payment?
    uid? && provider? && access_code? && publishable_key?
  end

end
