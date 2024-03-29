class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = contains_date_params? ? current_user.events.scheduled.date_range(params[:start], params[:end]) : Event.none

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def manager
    if current_user.employees.present? && contains_date_params?
      @events = Event.where(user_id: current_user.employees).scheduled.date_range(params[:start], params[:end])
    else
      @events = Event.none
    end

    respond_to do |format|
      format.json { render json: @events.as_json(display: "email") }
    end
  end

  def company
    if current_user.subscriber && contains_date_params?
      @events = Event.where(user_id: current_user.subscriber.users).scheduled.date_range(params[:start], params[:end])
    else
      @events = Event.none
    end

    respond_to do |format|
      format.json { render json: @events.as_json(display: "email") }
    end
  end

  def create
    @event = current_user.events.create!(event_params)
    track_activity!(@event)

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    old_duration = @event.duration
    @event.update!(event_params)
    @event.update_leave!(old_duration)
    track_activity!(@event)

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.cancel!
    track_activity!(@event)
    head :ok
  end

  private

  def contains_date_params?
    params[:start] && params[:end]
  end

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :ends_at, :all_day, :approved, :kind)
  end
end
