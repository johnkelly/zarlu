class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_paid_account!

  def show
    @events = current_user.events.lifo
    @pending_events = @events.pending
    @rejected_events = @events.rejected
  end
end
