class CompanySetting < ActiveRecord::Base
  belongs_to :subscriber

  attr_accessible :subscriber_id, :enabled, :default_accrual_rate, :accrual_frequency, :start_accrual
  validates_presence_of :subscriber_id
  validates_numericality_of :default_accrual_rate, allow_nil: true, greater_than_or_equal_to: 0

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

  def display_start_accrual
    start_accrual.strftime('%m-%d-%Y') if start_accrual.present?
  end
end

