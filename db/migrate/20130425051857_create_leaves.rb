class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.string :type
      t.integer :user_id
      t.decimal :accrued_hours, default: 0

      t.timestamps
    end
  end
end
