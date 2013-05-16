class Event < ActiveRecord::Base
  belongs_to :user, touch: true

  validates_presence_of :user_id, :kind

  scope :before, ->(end_time) { where("ends_at < ?", Event.format_date(end_time)) }
  scope :after, ->(start_time) { where("starts_at > ?", Event.format_date(start_time)) }
  scope :not_rejected, -> { where(rejected: false) }
  scope :rejected, -> { where(rejected: true) }
  scope :pending, -> { where(approved: false, rejected: false) }
  scope :lifo, -> { order("created_at desc") }

  after_create :approve!, if: Proc.new {|event| event.user.manager_id == nil }
  after_create :increment_pending_leave!, unless: Proc.new { |event| event.approved? }
  after_destroy :decrement_leave_usage!, if: Proc.new { |event| event.approved? }
  after_destroy :decrement_pending_leave!, unless: Proc.new { |event| event.approved? }

  VACATION = 0
  SICK = 1
  HOLIDAY = 2
  PERSONAL = 3
  UNPAID = 4
  OTHER = 5

  def self.date_range(start_date, end_date)
    range = self.after(start_date.to_i - 1.day.to_i)
    range << before(end_date.to_i + 1.day.to_i)
    range.uniq
  end

  def self.kinds
    [
      ["Vacation", VACATION],
      ["Sick", SICK],
      ["Holiday", HOLIDAY],
      ["Personal", PERSONAL],
      ["Unpaid", UNPAID],
      ["Other", OTHER]
    ]
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

  def unapprove!
    if approved
      transaction do
        remove_used_and_add_pending_leave
        self.update!(approved: false)
      end
    end
  end

  def color
    case kind
    when VACATION
      "#0668C0"
    when SICK
      "green"
    when HOLIDAY
      "#FF5E00"
    when PERSONAL
      "purple"
    when UNPAID
      "red"
    when OTHER
      "black"
    end
  end

  def duration
    if all_day
      calculate_all_day_duration
    else
      calculate_event_duration
    end
  end

  def kind_name
    ::Event.kinds[kind].first
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

  def remove_used_and_add_pending_leave
    decrement_leave_usage!
    increment_pending_leave!
  end

  def increment_leave_usage!
    event_user_leave.update!(used_hours: (event_user_leave.used_hours + self.duration))
  end

  def decrement_leave_usage!
    event_user_leave.update!(used_hours: (event_user_leave.used_hours - self.duration))
  end

  def increment_pending_leave!
    event_user_leave.update!(pending_hours: (event_user_leave.pending_hours + self.duration))
  end

  def decrement_pending_leave!
    event_user_leave.update!(pending_hours: (event_user_leave.pending_hours - self.duration))
  end

  def event_user_leave
    leave_klass = "#{kind_name}Leave".constantize
    leave_klass.where(user_id: user_id).first
  end
end
