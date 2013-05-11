desc 'This task is run by a chron job to update accrual totals'
task update_accrual_hours: :environment do
  FindAccrualWorker.perform_async
end