class EventDurationService
  attr_reader :vacation_hours, :sick_hours, :holiday_hours, :personal_hours, :unpaid_hours, :other_hours

  def initialize(events)
    @events = events
    @vacation_hours = @events.select{ |e| e.kind == Event::VACATION }.map(&:duration).inject(0, :+)
    @sick_hours = @events.select{ |e| e.kind == Event::SICK }.map(&:duration).inject(0, :+)
    @holiday_hours = @events.select{ |e| e.kind == Event::HOLIDAY }.map(&:duration).inject(0, :+)
    @personal_hours = @events.select{ |e| e.kind == Event::PERSONAL }.map(&:duration).inject(0, :+)
    @unpaid_hours = @events.select{ |e| e.kind == Event::UNPAID }.map(&:duration).inject(0, :+)
    @other_hours = @events.select{ |e| e.kind == Event::OTHER }.map(&:duration).inject(0, :+)
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
end
