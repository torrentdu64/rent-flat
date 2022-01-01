class AddChargeEnabledToStripeAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :stripe_accounts, :charges_enabled, :boolean, default: false
  end
end
