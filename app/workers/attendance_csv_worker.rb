class AttendanceCsvWorker
  include Sidekiq::Worker

  def perform
    AttendanceCsv.process_csvs
  end
end
