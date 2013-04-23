class PersonalCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Personal", Event::PERSONAL]
  end
end
