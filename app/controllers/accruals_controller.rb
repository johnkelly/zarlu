class AccrualsController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  def create
    @subscriber = current_user.subscriber
    @accrual = accrual_klass.new(permitted_accruals)
    if @accrual.save
      redirect_to company_settings_url, notice: "Accrual rate added."
    else
      redirect_to company_settings_url, alert: @accrual.errors.full_messages.first
    end
  end

  def destroy
    @subscriber = current_user.subscriber
    @accrual = @subscriber.accruals.find(params[:id])
    @accrual.destroy
    redirect_to company_settings_url, notice: "Accrual rate removed"
  end


  private

  def accrual_params
    params[:vacation_accrual].presence || params[:sick_accrual].presence || params[:holiday_accrual].presence || params[:personal_accrual].presence || params[:unpaid_accrual].presence || params[:other_accrual].presence
  end

  def permitted_accruals
    accrual_params.permit(:start_year, :end_year, :rate).merge(subscriber_id: @subscriber.id)
  end

  def accrual_klass
    case params[:type].to_i
    when Event::VACATION
      VacationAccrual
    when Event::SICK
      SickAccrual
    when Event::HOLIDAY
      HolidayAccrual
    when Event::PERSONAL
      PersonalAccrual
    when Event::UNPAID
      UnpaidAccrual
    when Event::OTHER
      OtherAccrual
    end
  end
end
