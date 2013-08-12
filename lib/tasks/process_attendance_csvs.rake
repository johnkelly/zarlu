desc 'This task is run by a chron job to process uploaded csv files'
task process_attendance_csvs: :environment do
  AttendanceCsvWorker.perform_async
end
