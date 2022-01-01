class CreateCopmanies < ActiveRecord::Migration[6.1]
  def change
    create_table :copmanies do |t|
      t.string :name
      t.string :address_line1
      t.string :address_postal_code
      t.string :address_city
      t.string :phone
      t.string :tax_id
      t.boolean :executives_provided
      t.boolean :owners_provided
      t.string :mcc
      t.references :stripe_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
