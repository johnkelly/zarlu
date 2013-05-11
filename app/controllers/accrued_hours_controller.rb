class AccruedHoursController < ApplicationController
  before_action :authenticate_manager!
  before_action :authenticate_paid_account!

  def update
    @leave = Leave.where(user_id: current_user.subscriber.users).find(params[:id])
    @leave.update!(setting_params.permit(:accrued_hours))
    respond_with_bip(@leave)
  end

  private

  def setting_params
    params[:vacation_leave].presence || params[:sick_leave].presence || params[:holiday_leave].presence || params[:personal_leave].presence || params[:unpaid_leave].presence || params[:other_leave].presence
  end
end
