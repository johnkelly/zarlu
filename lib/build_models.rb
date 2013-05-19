module BuildModels
  def self.builder
    Proc.new do
      trial_subscriber = Subscriber.create!
      expired_subscriber = Subscriber.create!(created_at: 31.days.ago)
      paid_subscriber = Subscriber.create!(customer_token: "FAKESTRIPETOKEN")

      manager = trial_subscriber.users.create!(email: "manager@example.com", password: "password", password_confirmation: "password", manager: true)
      user = trial_subscriber.users.create!(email: "test@example.com", password: "password", password_confirmation: "password", manager_id: manager.id)

      expired_manager = expired_subscriber.users.create!(email: "expiredmanager@example.com", password: "password", password_confirmation: "password", manager: true)
      paid_manager = paid_subscriber.users.create!(email: "paidmanager@example.com", password: "password", password_confirmation: "password", manager: true)

      event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
      allday_event = user.events.create!(title: "All day", description: "From the lib file", starts_at: Date.current.midnight, ends_at: (Date.current.midnight + 1.minute), all_day: true)
    end
  end
end
