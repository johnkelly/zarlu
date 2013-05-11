class UpdateAccrualWorker
  include Sidekiq::Worker

  def perform(company_setting_id)
    company_setting = CompanySetting.find(company_setting_id)
    if company_setting.accrues_today?
      Leave.update_accrued_hours(users(company_setting), accrual_rate(company_setting), leave_type(company_setting))
      company_setting.set_next_accrual_date!
    end
  end


  private

  def leave_type(company_setting)
    company_setting.kind[0]
  end

  def accrual_rate(company_setting)
    company_setting.default_accrual_rate
  end

  def users(company_setting)
    company_setting.subscriber.users
  end
end
