class PendingEventEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    EventMailer.pending(user_id).deliver
  end
end
