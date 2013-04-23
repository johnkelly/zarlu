class SickCompanySetting < CompanySetting
  belongs_to :subscriber
  validates_presence_of :type

  def kind
    ["Sick", Event::SICK]
  end
end
