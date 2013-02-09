class SchedulesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @events = current_user.events.lifo
    @pending_events = @events.pending
    @rejected_events = @events.rejected
  end
end
