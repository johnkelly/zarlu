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
      redirect_to manager_setup_complete_path, notice: "Your data was successfully uploaded and may take a few minutes to process."
    else
      redirect_to manager_setup_data_path, alert: @attendance_csv.errors.full_messages.first
    end
  end

  private

  def attendance_params
    params.require(:attendance_csv).permit(:csv)
  end
end
