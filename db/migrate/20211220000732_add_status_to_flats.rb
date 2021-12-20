class AddStatusToFlats < ActiveRecord::Migration[6.1]
  def change
    add_column :flats, :status, :string, default: 'pending'
  end
end
