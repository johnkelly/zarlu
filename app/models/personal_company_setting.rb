class PersonalCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Personal", TimeOffValue::PERSONAL]
  end
end
