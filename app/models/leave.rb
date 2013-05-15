class Leave < ActiveRecord::Base
  belongs_to :user, touch: true

  validates_presence_of :user_id
  validates_numericality_of :accrued_hours, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :used_hours, allow_nil: true
  validates_numericality_of :pending_hours, allow_nil: true

  def self.update_accrued_hours(users, accrual_rate, kind)
    leave_to_update = leave_klass(kind).where(user_id: users)
    leave_to_update.each { |leave| leave.increment_accrual_hours!(accrual_rate) }
  end

  def increment_accrual_hours!(accrual_rate)
    update!(accrued_hours: (accrued_hours + accrual_rate))
  end

  private

  def self.leave_klass(kind)
    (kind.titleize + "Leave").constantize
  end
end
