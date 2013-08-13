class ImportAttendanceController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  def new
    @subscriber = current_user.subscriber
    @attendance_csv = @subscriber.attendance_csvs.new
  end

  def create
    @subscriber = current_user.subscriber
    @attendance_csv = @subscriber.attendance_csvs.new(attendance_params)
    if @attendance_csv.save
      ProcessAttendanceCsvWorker.perform_in(1.minutes, @attendance_csv.id)
      redirect_to manager_setup_complete_path, notice: "Your data was successfully uploaded and may take a 1-2 minutes to process."
    else
      redirect_to manager_setup_data_path, alert: @attendance_csv.errors.full_messages.first
    end
  end

  private

  def attendance_params
    params.require(:attendance_csv).permit(:csv)
  end
end
