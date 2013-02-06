class AddApprovedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean, default: false, null: false
    add_column :events, :rejected, :boolean, default: false, null: false
  end
end
