class CompanySetting < ActiveRecord::Base
  belongs_to :subscriber

  attr_accessible :subscriber_id, :enabled, :default_accrual_rate
  validates_presence_of :subscriber_id
  validates_numericality_of :default_accrual_rate, allow_nil: true, greater_than_or_equal_to: 0
end

