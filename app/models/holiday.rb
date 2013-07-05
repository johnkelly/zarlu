class Holiday < ActiveRecord::Base
  belongs_to :subscriber, touch: true

  validates_presence_of :subscriber_id, :name, :date

  scope :chronological, -> { order("date asc") }
  scope :between, ->(start_date, end_date) { where("date > ? AND date < ?", start_date, end_date) }

  def as_json(options = {})
    {
      id: id,
      title: name,
      description: "",
      start: date,
      end: date,
      allDay: true,
      recurring: false,
      color: "#FF5E00",
      approved: true
    }
  end
end
