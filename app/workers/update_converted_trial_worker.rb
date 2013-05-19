class UpdateConvertedTrialWorker
  include Sidekiq::Worker

  def perform
    Subscriber.expired_yesterday_with_credit_card.each do |subscriber|
      subscriber.update_subscription_users
    end
  end
end
