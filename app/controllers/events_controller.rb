class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = contains_date_params? ? current_user.events.not_rejected.date_range(params[:start], params[:end]) : []

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def create
    @event = current_user.events.create!(params[:event])
    track_activity!(@event)

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    @event.update_attributes!(params[:event])
    track_activity!(@event)

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy
    track_activity!(@event)

    head :ok
  end

  private

  def contains_date_params?
    params[:start] && params[:end]
  end
end
