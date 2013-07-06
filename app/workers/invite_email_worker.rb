class InviteEmailWorker
  include Sidekiq::Worker

  def perform(manager_id, user_id)
    UserMailer.invite(manager_id, user_id).deliver
  end
end