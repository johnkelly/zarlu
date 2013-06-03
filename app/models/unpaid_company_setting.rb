class UnpaidCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Unpaid", TimeOffValue::UNPAID]
  end
end
