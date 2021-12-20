class AddCardInfoToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscribed, :boolean, default: false
    add_column :users, :card_last4, :string
    add_column :users, :card_exp_month, :string
    add_column :users, :card_exp_year, :string
    add_column :users, :card_type, :string
  end
end
