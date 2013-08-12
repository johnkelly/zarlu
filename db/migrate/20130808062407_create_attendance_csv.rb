class CreateAttendanceCsv < ActiveRecord::Migration
  def change
    create_table :attendance_csvs do |t|
      t.integer :subscriber_id
      t.string :csv

      t.timestamps
    end

    add_index :attendance_csvs, :subscriber_id
  end
end
