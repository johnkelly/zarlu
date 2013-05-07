class EventDurationService
  attr_reader :vacation_hours, :sick_hours, :holiday_hours, :personal_hours, :unpaid_hours, :other_hours

  def initialize(events)
    @events = events
    @vacation_hours = sum_durations(@events, Event::VACATION)
    @sick_hours = sum_durations(@events, Event::SICK)
    @holiday_hours = sum_durations(@events, Event::HOLIDAY)
    @personal_hours = sum_durations(@events, Event::PERSONAL)
    @unpaid_hours = sum_durations(@events, Event::UNPAID)
    @other_hours = sum_durations(@events, Event::OTHER)
  end

  def unpaid_and_other_hours
    unpaid_hours + other_hours
  end

  def pie_chart_data
    [vacation_hours, sick_hours, holiday_hours, personal_hours, unpaid_hours, other_hours]
  end

  def any?
    vacation_hours > 0 || sick_hours > 0 || holiday_hours > 0 || personal_hours > 0 || unpaid_hours > 0 || other_hours > 0
  end

  private

  def sum_durations(events, type)
    events.select{ |e| e.kind == type }.map(&:duration).inject(0, :+)
  end
end
