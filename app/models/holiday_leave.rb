class HolidayLeave < Leave
  belongs_to :user, touch: true

  validates_presence_of :type

  private

  def accrual_limit
    user.subscriber.holiday_company_setting.accrual_limit
  end
end

