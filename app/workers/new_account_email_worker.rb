class NewAccountEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    UserMailer.new_account(user_id).deliver
  end
end