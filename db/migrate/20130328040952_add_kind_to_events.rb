class AddKindToEvents < ActiveRecord::Migration
  def change
    add_column :events, :kind, :integer, default: 0, null: false
  end
end
