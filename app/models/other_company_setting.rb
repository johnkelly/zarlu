class OtherCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Other", TimeOffValue::OTHER]
  end
end
