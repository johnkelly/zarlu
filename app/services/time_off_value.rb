class TimeOffValue
  VACATION = 0
  SICK = 1
  PERSONAL = 2
  UNPAID = 3
  OTHER = 4

  def self.kinds
    [
      ["Vacation", VACATION],
      ["Sick", SICK],
      ["Personal", PERSONAL],
      ["Unpaid", UNPAID],
      ["Other", OTHER]
    ]
  end

  def self.color(kind)
    case kind
    when VACATION
      "#0668C0"
    when SICK
      "green"
    when PERSONAL
      "purple"
    when UNPAID
      "red"
    when OTHER
      "black"
    end
  end
end
