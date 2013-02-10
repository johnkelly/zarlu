module BuildModels
  def self.builder
    Proc.new do
      coach_subscriber = Subscriber.create!(plan: "coach")
      business_subscriber = Subscriber.create!(plan: "business")
      business_select_subscriber = Subscriber.create!(plan: "business_select")
      first_class_subscriber = Subscriber.create!(plan: "first_class")

      manager = coach_subscriber.users.create!(email: "manager@example.com", password: "password", password_confirmation: "password", manager: true)
      user = coach_subscriber.users.create!(email: "test@example.com", password: "password", password_confirmation: "password", manager_id: manager.id)

      no_cc_user = business_subscriber.users.create!(email: "freeloader@example.com", password: "password", password_confirmation: "password", manager: true)

      event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
    end
  end
end
