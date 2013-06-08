class RejectEventEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    EventMailer.rejected(user_id).deliver
  end
end
