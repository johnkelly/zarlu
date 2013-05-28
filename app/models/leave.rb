class Leave < ActiveRecord::Base
  belongs_to :user, touch: true

  validates_presence_of :user_id
  validates_numericality_of :accrued_hours, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :used_hours, allow_nil: true
  validates_numericality_of :pending_hours, allow_nil: true

  delegate :accrual_rate, to: :user

  def self.update_accrued_hours(users, kind)
    leave_to_update = leave_klass(kind).where(user_id: users)
    leave_to_update.each { |leave| leave.increment_accrual_hours!(leave.accrual_rate(accrual_type(kind))) unless leave.at_accrual_limit? }
  end

  def increment_accrual_hours!(accrual_rate)
    if accrual_rate_will_go_over_limit?(accrual_rate)
      update!(accrued_hours: accrual_limit)
    else
      update!(accrued_hours: (accrued_hours + accrual_rate))
    end
  end

  def at_accrual_limit?
    if accrual_limit.present?
      accrual_limit <= available_hours
    else
      false
    end
  end

  def available_hours
    accrued_hours - used_hours
  end

  private

  def self.leave_klass(kind)
    (kind.titleize + "Leave").constantize
  end

  def self.accrual_type(kind)
    (kind.titleize + "Accrual")
  end

  def accrual_rate_will_go_over_limit?(accrual_rate)
    accrual_limit.present? && (accrual_rate + available_hours > accrual_limit)
  end
end
