class LeavesController < ApplicationController
  before_action :authenticate_user!

  def show
    @leave = current_user.leaves.where(type: leave_klass).first
    respond_to do |format|
      format.json { render json: @leave }
    end
  end

  private

  def time_off_kind
    TimeOffValue.kinds[(params[:kind].to_i)].first
  end

  def leave_klass
    (time_off_kind + "Leave").constantize
  end
end

