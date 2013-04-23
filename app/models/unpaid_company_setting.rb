class UnpaidCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Unpaid", Event::UNPAID]
  end
end
