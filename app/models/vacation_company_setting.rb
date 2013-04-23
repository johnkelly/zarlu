class VacationCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Vacation", Event::VACATION]
  end
end
