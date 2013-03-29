class ActivityWorker
  include Sidekiq::Worker

  def perform(user_id, action, trackable_klass, trackable_id)
    user = User.where(id: user_id).first
    trackable = trackable_klass.constantize.where(id: trackable_id).first
    if user.present? && trackable.present?
      user.activities.create!(action: action, trackable: trackable)
    end
  end
end
