class Event < ActiveRecord::Base
  belongs_to :user, touch: true

  validates_presence_of :user_id, :kind

  scope :before, ->(end_time) { where("ends_at < ?", Event.format_date(end_time)) }
  scope :after, ->(start_time) { where("starts_at > ?", Event.format_date(start_time)) }
  scope :not_rejected, -> { where(rejected: false) }
  scope :rejected, -> { where(rejected: true) }
  scope :pending, -> { where(approved: false, rejected: false) }
  scope :lifo, -> { order("created_at desc") }

  after_create :increment_leave_and_approve_no_manager_leave!
  after_destroy :decrement_leave!

  def self.date_range(start_date, end_date)
    range = self.after(start_date.to_i - 1.day.to_i)
    range << before(end_date.to_i + 1.day.to_i)
    range.uniq
  end

  def as_json(options = {})
    {
      id: id,
      title: event_title(options),
      description: description,
      start: starts_at,
      end: ends_at,
      allDay: all_day,
      recurring: false,
      color: color,
      approved: approved
    }
  end

  def approve!
    transaction do
      add_used_and_remove_pending_leave
      self.update!(approved: true)
    end
  end

  def reject!
    self.rejected = true
    self.save!
  end

  def unapprove!(old_duration)
    if approved?
      transaction do
        remove_used_and_add_pending_leave(old_duration)
        self.update!(approved: false)
      end
    end
  end

  def color
    TimeOffValue.color(kind)
  end

  def duration
    if all_day
      calculate_all_day_duration
    else
      calculate_event_duration
    end
  end

  def kind_name
    TimeOffValue.kinds[kind].first
  end

  def update_leave!(old_duration)
    if approved?
      if user.has_manager?
        unapprove!(old_duration)
      else
        change_used_leave_duration!(old_duration)
      end
    else
      change_pending_leave_duration!(old_duration)
    end
  end

  private

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def event_title(options)
    (options && options[:display] == "email") ? user.display_name : title
  end

  def calculate_all_day_duration
    if ends_at.present?
      (((ends_at - starts_at) / 1.day) + 1).to_i * 8
    else
      8
    end
  end

  def calculate_event_duration
    hours_off = ((ends_at - starts_at) / 1.hour).round(2)
    if hours_off > 8
      8
    else
      hours_off
    end
  end

  def add_used_and_remove_pending_leave
    increment_leave_usage!
    decrement_pending_leave!
  end

  def remove_used_and_add_pending_leave(old_duration)
    decrement_leave_usage!(old_duration)
    increment_pending_leave!
  end

  def decrement_leave!
    if approved?
      decrement_leave_usage!
    else
      decrement_pending_leave!
    end
  end

  def increment_leave_and_approve_no_manager_leave!
    increment_pending_leave!
    approve! unless user.has_manager?
  end

  def increment_leave_usage!
    event_user_leave.update!(used_hours: (event_user_leave.used_hours + self.duration))
  end

  def decrement_leave_usage!(old_duration = self.duration)
    event_user_leave.update!(used_hours: (event_user_leave.used_hours - old_duration))
  end

  def increment_pending_leave!
    event_user_leave.update!(pending_hours: (event_user_leave.pending_hours + self.duration))
  end

  def decrement_pending_leave!
    event_user_leave.update!(pending_hours: (event_user_leave.pending_hours - self.duration))
  end

  def change_used_leave_duration!(old_duration)
    event_user_leave.update!(used_hours: (event_user_leave.used_hours - old_duration + self.duration))
  end

  def change_pending_leave_duration!(old_duration)
    event_user_leave.update!(pending_hours: (event_user_leave.pending_hours - old_duration + self.duration))
  end

  def event_user_leave
    leave_klass = "#{kind_name}Leave".constantize
    leave_klass.where(user_id: user_id).first
  end
end
