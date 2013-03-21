class ChargeCreditCardWorker
  include Sidekiq::Worker

  def perform(subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    subscriber.add_or_update_subscription
  end
end
