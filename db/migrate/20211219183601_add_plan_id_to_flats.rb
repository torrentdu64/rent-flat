class AddPlanIdToFlats < ActiveRecord::Migration[6.1]
  def change
    add_column :flats, :stripe_plan_id, :string
  end
end
