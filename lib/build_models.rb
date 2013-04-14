module BuildModels
  def self.builder
    Proc.new do
      unpaid_subscriber = Subscriber.create!
      paid_subscriber = Subscriber.create!(plan: "public_paid_plan")

      manager = unpaid_subscriber.users.create!(email: "manager@example.com", password: "password", password_confirmation: "password", manager: true)
      user = unpaid_subscriber.users.create!(email: "test@example.com", password: "password", password_confirmation: "password", manager_id: manager.id)

      no_cc_user = paid_subscriber.users.create!(email: "freeloader@example.com", password: "password", password_confirmation: "password", manager: true)

      event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
      allday_event = user.events.create!(title: "All day", description: "From the lib file", starts_at: Date.today.midnight, ends_at: Date.today.midnight, all_day: true)
    end
  end
end
