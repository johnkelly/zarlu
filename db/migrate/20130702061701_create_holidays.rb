class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.integer :subscriber_id
      t.string :name
      t.date :date
    end

    add_index :holidays, :subscriber_id
  end
end
