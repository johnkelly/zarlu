class AttendanceCsvRow
  include ActiveModel::Model

  attr_accessor :email, :hire_date, :vacation_balance, :sick_balance, :personal_balance, :unpaid_balance, :other_balance
  validates_presence_of :email, :hire_date, :vacation_balance, :sick_balance, :personal_balance, :unpaid_balance, :other_balance
  validates_numericality_of :vacation_balance, :sick_balance, :personal_balance, :unpaid_balance, :other_balance
  validates_format_of :hire_date, with: /\A(\d{1,2}+(\/|-)){2}\d{4}\z/

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value.to_s.strip)
    end
  end

  def import(subscriber_id)
    current_user = user(subscriber_id)
    update_hire_date!(current_user)
    update_accrued_hours!(current_user)
  end

  private

  def user(subscriber_id)
    subscriber = Subscriber.find(subscriber_id)
    existing_user = subscriber.users.where(email: email).first
    existing_user.presence || invite_user(email, subscriber)
  end

  def invite_user(email, subscriber)
    User.invite!({ email: email, subscriber_id: subscriber.id })
  end

  def update_hire_date!(user)
    date = hire_date.split(/[\/-]/).map(&:to_i)
    join_date = Date.new(date[2], date[0], date[1])
    user.update!(join_date: join_date)
  end

  def update_accrued_hours!(user)
    user.vacation_leave.update!(accrued_hours: vacation_balance)
    user.sick_leave.update!(accrued_hours: sick_balance)
    user.personal_leave.update!(accrued_hours: personal_balance)
    user.unpaid_leave.update!(accrued_hours: unpaid_balance)
    user.other_leave.update!(accrued_hours: other_balance)
  end
end
