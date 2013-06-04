class AccruedHoursController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  def update
    @leave = Leave.where(user_id: current_user.subscriber.users).find(params[:id])
    @leave.update(setting_params)
    respond_with_bip(@leave, { param_key: :leave })
  end

  private

  def setting_params
    params.require(:leave).permit(:accrued_hours)
  end
end
