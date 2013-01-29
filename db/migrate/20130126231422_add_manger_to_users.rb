class AddMangerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :manager_id, :integer
    add_column :users, :manager, :boolean, default: false, null: false
  end
end
