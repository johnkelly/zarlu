class ChargeCreditCardWorker
  include Sidekiq::Worker

  def perform(subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    subscriber.update_subscription_users
  end
end
