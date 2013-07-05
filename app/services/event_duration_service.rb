class EventDurationService
  attr_reader :vacation_hours, :sick_hours, :personal_hours, :unpaid_hours, :other_hours

  def initialize(events)
    @events = events
    @vacation_hours = sum_durations(@events, TimeOffValue::VACATION)
    @sick_hours = sum_durations(@events, TimeOffValue::SICK)
    @personal_hours = sum_durations(@events, TimeOffValue::PERSONAL)
    @unpaid_hours = sum_durations(@events, TimeOffValue::UNPAID)
    @other_hours = sum_durations(@events, TimeOffValue::OTHER)
  end

  def unpaid_and_other_hours
    unpaid_hours + other_hours
  end

  def pie_chart_data
    [vacation_hours, sick_hours, personal_hours, unpaid_hours, other_hours]
  end

  def any?
    vacation_hours > 0 || sick_hours > 0 || personal_hours > 0 || unpaid_hours > 0 || other_hours > 0
  end

  private

  def sum_durations(events, type)
    events.select{ |e| e.kind == type }.map(&:duration).inject(0, :+)
  end
end
