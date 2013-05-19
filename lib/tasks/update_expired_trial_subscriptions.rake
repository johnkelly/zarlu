desc 'This task is run by a chron job to update stripe user account for trials that converted.'
task update_expired_trial_subscriptions: :environment do
  UpdateConvertedTrialWorker.perform_async
end
