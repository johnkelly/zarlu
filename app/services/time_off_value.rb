class TimeOffValue
  VACATION = 0
  SICK = 1
  HOLIDAY = 2
  PERSONAL = 3
  UNPAID = 4
  OTHER = 5

  def self.kinds
    [
      ["Vacation", VACATION],
      ["Sick", SICK],
      ["Holiday", HOLIDAY],
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
    when HOLIDAY
      "#FF5E00"
    when PERSONAL
      "purple"
    when UNPAID
      "red"
    when OTHER
      "black"
    end
  end
end
