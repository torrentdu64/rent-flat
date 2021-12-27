class MerchantSettingsController < ApplicationController
  before_action :authenticate_user!

  def connect

    #byebug
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    if !current_user.uid.present?
      account = Stripe::Account.create(
        type: 'express',
        country: 'NZ',
        email: current_user.email,
        capabilities: {
          card_payments: {requested: true},
          transfers: {requested: true},
        },
        business_type: 'individual',
        individual: {
          email: current_user.email,
        }
      )

      p account



      current_user.update(
        #is_host: true,
        uid: account.id,
        )

    end

    p link = Stripe::AccountLink.create(
      account: current_user.uid,
      refresh_url: 'https://b8c6-219-88-232-231.ngrok.io/users/edit' ,
      return_url:  'https://b8c6-219-88-232-231.ngrok.io/users/edit',
      type: 'account_onboarding',
      collect: 'eventually_due',
      )


    redirect_to link.url, status: :see_other, allow_other_hosts: true
  end


end
