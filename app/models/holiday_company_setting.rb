class HolidayCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Holiday", Event::HOLIDAY]
  end
end
