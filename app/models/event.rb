class Event < ActiveRecord::Base
  attr_accessible :title, :description, :starts_at, :ends_at, :all_day

  scope :before, ->(end_time) { where("ends_at < ?", Event.format_date(end_time)) }
  scope :after, ->(start_time) { where("starts_at > ?", Event.format_date(start_time)) }

  def self.date_range(start_date, end_date)
    range = self.after(start_date)
    range << before(end_date)
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

  private

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end
end
