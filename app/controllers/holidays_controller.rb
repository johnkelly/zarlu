class HolidaysController < ApplicationController
  before_action :authenticate_user!, only: %w[index]
  before_action :authenticate_manager!, except: %w[index]
  before_action :check_if_trial_or_cc!, except: %w[index]

  def index
    @holidays = contains_date_params? ? current_user.subscriber.holidays.between(start_date, end_date) : Holiday.none

    respond_to do |format|
      format.json { render json: @holidays }
    end
  end

  def create
    @subscriber = current_user.subscriber
    @holiday = @subscriber.holidays.new(name: holiday_params[:name], date: american_date)
    if @holiday.save
      redirect_to company_settings_url, notice: "Holiday added."
    else
      redirect_to company_settings_url, alert: @holiday.errors.full_messages.first
    end
  end

  def destroy
    @subscriber = current_user.subscriber
    @holiday = @subscriber.holidays.find(params[:id])
    @holiday.destroy
    redirect_to company_settings_url, notice: "Holiday deleted."

  end

  private

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end

  def american_date
    Date.strptime(holiday_params[:date], "%m/%d/%Y")
  end

  def contains_date_params?
    params[:start] && params[:end]
  end

  def start_date
    Time.at(params[:start].to_i).to_date
  end

  def end_date
    Time.at(params[:end].to_i).to_date
  end
end
