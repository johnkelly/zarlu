class AccrualService
  attr_reader :vacation, :sick, :personal, :unpaid, :other

  def initialize(accruals)
    @accruals = accruals.sort_by(&:start_year)
    @vacation = @accruals.select{ |accrual| accrual.is_a?(VacationAccrual) }
    @sick = @accruals.select{ |accrual| accrual.is_a?(SickAccrual) }
    @personal = @accruals.select{ |accrual| accrual.is_a?(PersonalAccrual) }
    @unpaid = @accruals.select{ |accrual| accrual.is_a?(UnpaidAccrual) }
    @other = @accruals.select{ |accrual| accrual.is_a?(OtherAccrual) }
  end
end
