class CompanySettingsController < ApplicationController
  before_filter :authenticate_manager!
  before_filter :authenticate_paid_account!

  def index
    @subscriber = current_user.subscriber
    @company_setting_service = CompanySettingService.new(@subscriber.company_settings)
    @time_zones = ActiveSupport::TimeZone.all.map{ |tz| [tz.name, tz.name] }
  end

  def update
    @subscriber = current_user.subscriber
    @company_setting = @subscriber.company_settings.find(params[:id])
    @company_setting.update_attributes!(setting_params)
    respond_with_bip(@company_setting)
  end

  private

  def setting_params
    params[:vacation_company_setting].presence || params[:sick_company_setting].presence || params[:holiday_company_setting].presence || params[:personal_company_setting].presence || params[:unpaid_company_setting].presence || params[:other_company_setting].presence
  end
end

