class ProcessAttendanceCsvWorker
  include Sidekiq::Worker

  def perform(attendance_csv_id)
    attendance_csv = AttendanceCsv.find(attendance_csv_id)
    unless attendance_csv.processed?
      attendance_csv.process_csv
    end
  end
end
