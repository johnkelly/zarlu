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

      canceled_event = user.events.create!(title: "Canceled", description: "From the lib file", starts_at: Date.current.midnight, ends_at: (Date.current.midnight + 1.minute), all_day: true)
      canceled_event.cancel!

      rejected_event = user.events.create!(title: "Rejected", description: "From the lib filed", starts_at: Date.current.midnight, ends_at: (Date.current.midnight + 1.minute), all_day: true)
      rejected_event.reject!

      vacation_accrual = trial_subscriber.vacation_accruals.create!(start_year: 10, end_year: 15, rate: 8.78)
      sick_accrual = trial_subscriber.sick_accruals.create!(start_year: 5, end_year: 8, rate: 13.04)
      personal_accrual = trial_subscriber.personal_accruals.create!(start_year: 2, end_year: 15, rate: 9.42)
      unpaid_accrual = trial_subscriber.unpaid_accruals.create!(start_year: 2, end_year: 4, rate: 5.23)
      other_accrual = trial_subscriber.other_accruals.create!(start_year: 3, end_year: 7, rate: 2.34)

      holiday = trial_subscriber.holidays.create!(name: "Independence Day", date: Date.new(Date.current.year, 7, 4))
      christmas = trial_subscriber.holidays.create!(name: "Christmas Day", date: Date.new(Date.current.year, 12, 25))

      attendance_csv = trial_subscriber.attendance_csvs.create!(csv: "https://www.zarlu.com")
      attendance_csv_2 = trial_subscriber.attendance_csvs.create!(csv: "https://www.favoriteplate.com")
    end
  end
end
