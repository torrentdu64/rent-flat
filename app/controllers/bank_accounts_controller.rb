class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    # Redirect if no stripe account exists yet
    unless current_user.uid
      redirect_to new_stripe_account_path and return
    end

    begin
      # Retrieve the account object for this user
      @account = Stripe::Account.retrieve(current_user.uid)

      @stripe_account = current_user.stripe_accounts.first

      # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      handle_error(e.message, 'new')

      # Handle any other exceptions
    rescue => e
      handle_error(e.message, 'new')
    end
  end

  def create

    # Redirect if no token is POSTed or the user doesn't have a Stripe account
    # unless params[:stripeToken] && current_user.uid
    #   redirect_to new_bank_account_path and return
    # end

    begin
      # Retrieve the account object for this user
       Stripe::Account.retrieve(current_user.uid)

      resp =  Stripe::Account.update(
        current_user.uid,
        {
            metadata: { info: 'info about object'},
            # tos_acceptance: {
            #   date: ,
            #   service_agreement: ,
            # },
            external_account: {
              object: "bank_account",
              country: "NZ",
              currency: "nzd",
              #routing_number:  params[:stripe_account][:routing_number],
              account_number: params[:stripe_account][:account_number]
            }
        })
      p resp
      @stripe_account = current_user.stripe_accounts.first
      # Create the bank account
      #account.external_account = params[:stripeToken]
      #p account.save

      # Success, send on to the dashboard
      flash[:success] = "Your bank account has been added!"
      redirect_to new_stripe_document_path

      # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      handle_error(e.message, 'new')

      # Handle any other exceptions
    rescue => e
      handle_error(e.message, 'new')
    end
  end

  private

  def account_params
    params.require(:stripe_account).permit(:country, :currency, :routing_number, :account_number)
  end

end
