class CreateAccruals < ActiveRecord::Migration
  def change
    create_table :accruals do |t|
      t.string :type
      t.integer :subscriber_id
      t.integer :start_year
      t.integer :end_year
      t.decimal :rate
    end
  end
end
