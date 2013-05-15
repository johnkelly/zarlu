class AddPendingHoursToLeaves < ActiveRecord::Migration
  def change
    add_column :leaves, :pending_hours, :decimal, default: 0, null: false
  end
end
