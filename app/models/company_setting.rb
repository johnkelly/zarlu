class CompanySetting < ActiveRecord::Base
  belongs_to :subscriber, touch: true

  validates_presence_of :subscriber_id, :accrual_frequency, :next_accrual
  validates_numericality_of :default_accrual_rate, greater_than_or_equal_to: 0

  before_validation :set_default_accrual_date_and_frequency, on: :create

  YEAR = 0
  QUARTER = 1
  MONTH = 2
  TWO_WEEKS = 3
  WEEK = 4
  DAY = 5

  def self.accrual_frequencies
    [
      [YEAR, "Year"],
      [QUARTER, "Quarter"],
      [MONTH, "Month"],
      [TWO_WEEKS, "2 weeks"],
      [WEEK, "Week"],
      [DAY, "Day"]
    ]
  end

  def self.update_accrual_hours
    find_each do |company_setting|
      if company_setting.accrues_today?
        UpdateAccrualWorker.perform_async(company_setting.id)
      end
    end
  end

  def display_next_accrual
    next_accrual.strftime('%m-%d-%Y')
  end

  def accrues_today?
    next_accrual == Date.today
  end

  def set_next_accrual_date!
    update!(next_accrual: calculate_next_accrual)
  end

  private

  def calculate_next_accrual
    case accrual_frequency
      when YEAR
        next_accrual + 1.year
      when QUARTER
        next_accrual + 3.months
      when MONTH
        next_accrual + 1.month
      when TWO_WEEKS
        next_accrual + 2.weeks
      when WEEK
        next_accrual + 1.week
      when DAY
        next_accrual + 1.day
    end
  end

  def set_default_accrual_date_and_frequency
    self.next_accrual = Date.today
    self.accrual_frequency = YEAR
  end
end

