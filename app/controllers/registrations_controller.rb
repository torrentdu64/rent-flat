class RegistrationsController < Devise::RegistrationsController

  def create

    super #We call super because we don't want to override this action
    current_user.stripe_accounts.create!(user_id: current_user.id)
    # redirect to dashboards_stripe_account_path
  end

  def edit
    @account = current_user.stripe_accounts.first || StripeAccount.new
    super
    #Custom code to override this action
  end

  def update
    super
    #byebug
  end

end