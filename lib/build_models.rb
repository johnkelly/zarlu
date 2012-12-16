module BuildModels
  def self.builder
    Proc.new do
      coach_subscriber = Subscriber.create!(plan: "coach")
      business_subscriber = Subscriber.create!(plan: "business")
      business_select_subscriber = Subscriber.create!(plan: "business_select")
      first_class_subscriber = Subscriber.create!(plan: "first_class")

      user = coach_subscriber.users.create!(email: "test@example.com", password: "password", password_confirmation: "password")
    end
  end
end
