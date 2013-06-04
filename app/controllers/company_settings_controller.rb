class CompanySettingsController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  etag { [current_user, flash] }

  def index
    @subscriber = current_user.subscriber
    @company_setting_service = CompanySettingService.new(@subscriber.company_settings)
    @accrual_service = AccrualService.new(@subscriber.accruals)
    @time_zones = ActiveSupport::TimeZone.all.map{ |tz| [tz.name, tz.name] }
    fresh_when(@subscriber)
  end

  def update
    @subscriber = current_user.subscriber
    @company_setting = @subscriber.company_settings.find(params[:id])
    if has_date_param?
      update_date_params
    else
    @company_setting.update(setting_params)
    end
    respond_with_bip(@company_setting, { param_key: :company_setting })
  end

  private

  def setting_params
    params.require(:company_setting).permit(:subscriber_id, :enabled, :accrual_frequency, :next_accrual, :accrual_limit)
  end

  def update_date_params
    @company_setting.update(next_accrual: Date.strptime(setting_params[:next_accrual], "%m/%d/%Y"))
  end

  def has_date_param?
    setting_params.keys.include?("next_accrual") && setting_params[:next_accrual].present?
  end
end

