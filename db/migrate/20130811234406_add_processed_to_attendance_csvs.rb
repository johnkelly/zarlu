class AddProcessedToAttendanceCsvs < ActiveRecord::Migration
  def change
    add_column :attendance_csvs, :processed, :boolean, default: false, null: false
  end
end
