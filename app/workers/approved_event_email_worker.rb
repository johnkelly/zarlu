class ApprovedEventEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    EventMailer.approved(user_id).deliver
  end
end
