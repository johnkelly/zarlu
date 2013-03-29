class Event < ActiveRecord::Base
  attr_accessible :title, :description, :starts_at, :ends_at, :all_day, :approved, :kind

  belongs_to :user

  validates_presence_of :user_id, :kind

  scope :before, ->(end_time) { where("ends_at < ?", Event.format_date(end_time)) }
  scope :after, ->(start_time) { where("starts_at > ?", Event.format_date(start_time)) }
  scope :not_rejected, -> { where(rejected: false) }
  scope :rejected, -> { where(rejected: true) }
  scope :pending, -> { where(approved: false, rejected: false) }
  scope :lifo, -> { order("created_at desc") }

  after_create :approve!, if: Proc.new {|event| event.user.manager_id == nil }

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
      color: color
    }
  end

  def approve!
    self.approved = true
    self.save!
  end

  def reject!
    self.rejected = true
    self.save!
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

  private

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def event_title(options)
    (options && options[:display] == "email") ? user.display_name : title
  end
end
