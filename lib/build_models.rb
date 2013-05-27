module BuildModels
  def self.builder
    Proc.new do
      trial_subscriber = Subscriber.create!(name: "trial")
      expired_subscriber = Subscriber.create!(name: "expired", created_at: 31.days.ago)
      paid_subscriber = Subscriber.create!(name: "paid", customer_token: "FAKESTRIPETOKEN")

      manager = trial_subscriber.users.create!(email: "manager@example.com", password: "password", password_confirmation: "password", manager: true)
      user = trial_subscriber.users.create!(email: "test@example.com", password: "password", password_confirmation: "password", manager_id: manager.id)

      expired_manager = expired_subscriber.users.create!(email: "expiredmanager@example.com", password: "password", password_confirmation: "password", manager: true)
      paid_manager = paid_subscriber.users.create!(email: "paidmanager@example.com", password: "password", password_confirmation: "password", manager: true)

      event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
      allday_event = user.events.create!(title: "All day", description: "From the lib file", starts_at: Date.current.midnight, ends_at: (Date.current.midnight + 1.minute), all_day: true)

      vacation_accrual = trial_subscriber.vacation_accruals.create!(start_year: 10, end_year: 15, rate: 8.78)
      sick_accrual = trial_subscriber.sick_accruals.create!(start_year: 5, end_year: 8, rate: 13.04)
      holiday_accrual = trial_subscriber.holiday_accruals.create!(start_year: 7, end_year: 25, rate: 3.23)
      personal_accrual = trial_subscriber.personal_accruals.create!(start_year: 2, end_year: 15, rate: 9.42)
      unpaid_accrual = trial_subscriber.unpaid_accruals.create!(start_year: 2, end_year: 4, rate: 5.23)
      other_accrual = trial_subscriber.other_accruals.create!(start_year: 3, end_year: 7, rate: 2.34)
    end
  end
end
