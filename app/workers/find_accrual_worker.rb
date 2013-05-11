class FindAccrualWorker
  include Sidekiq::Worker

  def perform
    CompanySetting.update_accrual_hours
  end
end