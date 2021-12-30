class AddBankAccountToStripeAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :stripe_accounts, :country, :string
    add_column :stripe_accounts, :currency, :string
    add_column :stripe_accounts, :routing_number, :string
    add_column :stripe_accounts, :account_number, :string
  end
end
