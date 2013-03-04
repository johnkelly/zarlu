class ActivityWorker
  include Sidekiq::Worker

  def perform(user_id, action, trackable_klass, trackable_id)
    user = User.find(user_id)
    trackable = trackable_klass.constantize.find(trackable_id)
    user.activities.create!(action: action, trackable: trackable)
  end
end
