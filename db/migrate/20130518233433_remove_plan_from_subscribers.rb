class RemovePlanFromSubscribers < ActiveRecord::Migration
  def change
    remove_column :subscribers, :plan, :string
  end
end
