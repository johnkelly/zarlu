class Event < ActiveRecord::Base
  attr_accessible :title, :description, :starts_at, :ends_at, :all_day, :approved

  belongs_to :user

  validates_presence_of :user_id

  scope :before, ->(end_time) { where("ends_at < ?", Event.format_date(end_time)) }
  scope :after, ->(start_time) { where("starts_at > ?", Event.format_date(start_time)) }
  scope :not_rejected, -> { where(rejected: false) }
  scope :rejected, -> { where(rejected: true) }
  scope :pending, -> { where(approved: false, rejected: false) }
  scope :lifo, -> { order("created_at desc") }

  after_create :approve!, if: Proc.new {|event| event.user.manager_id == nil }

  def self.date_range(start_date, end_date)
    range = self.after(start_date.to_i - 1.day.to_i)
    range << before(end_date.to_i + 1.day.to_i)
    range.uniq
  end

  def as_json(options = {})
    {
      id: id,
      title: title,
      description: description,
      start: starts_at,
      end: ends_at,
      allDay: all_day,
      recurring: false,
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

  private

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
end
