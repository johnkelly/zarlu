class EventsController < ApplicationController
  def index
    @events = contains_date_params? ? Event.date_range(params[:start], params[:end]) : []

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def create
    @event = Event.create!(params[:event])

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes!(params[:event])

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  private

  def contains_date_params?
    params[:start] && params[:end]
  end
end
