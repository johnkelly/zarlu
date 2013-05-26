class OtherLeave < Leave
  belongs_to :user, touch: true

  validates_presence_of :type

  private

  def accrual_limit
    user.subscriber.other_company_setting.accrual_limit
  end
end

