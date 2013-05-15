class AddUsedHoursToLeaves < ActiveRecord::Migration
  def change
    add_column :leaves, :used_hours, :decimal, default: 0, null: false
  end
end
