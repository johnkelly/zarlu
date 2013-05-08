class CompanySettingsController < ApplicationController
  before_action :authenticate_manager!
  before_action :authenticate_paid_account!

  def index
    @subscriber = current_user.subscriber
    @company_setting_service = CompanySettingService.new(@subscriber.company_settings)
    @time_zones = ActiveSupport::TimeZone.all.map{ |tz| [tz.name, tz.name] }
  end

  def update
    @subscriber = current_user.subscriber
    @company_setting = @subscriber.company_settings.find(params[:id])
    if has_date_param?
      update_date_params
    else
    @company_setting.update!(permitted_settings)
    end
    respond_with_bip(@company_setting)
  end

  private

  def setting_params
    params[:vacation_company_setting].presence || params[:sick_company_setting].presence || params[:holiday_company_setting].presence || params[:personal_company_setting].presence || params[:unpaid_company_setting].presence || params[:other_company_setting].presence
  end

  def permitted_settings
    setting_params.permit(:subscriber_id, :enabled, :default_accrual_rate, :accrual_frequency, :start_accrual)
  end

  def update_date_params
    @company_setting.update!(start_accrual: Date.strptime(setting_params[:start_accrual], "%m/%d/%Y"))
  end

  def has_date_param?
    setting_params.keys.include?("start_accrual") && setting_params[:start_accrual].present?
  end
end
