class Accrual < ActiveRecord::Base
  belongs_to :subscriber, touch: true

  validates_presence_of :subscriber_id
  validates_numericality_of :start_year, greater_than_or_equal_to: 0
  validates_numericality_of :end_year, greater_than_or_equal_to: 0
  validates_numericality_of :rate, greater_than_or_equal_to: 0
  before_save :start_year_less_than_end_year
  before_save :subscriber_accruals_cant_overlap

  def start_year_less_than_end_year
    unless start_year < end_year
      errors.add(:base, "Start year must be less than end year.")
      false
    end
  end

  def subscriber_accruals_cant_overlap
    no_overlap = true
    subscriber.accruals.where(type: type).each do |accrual|
      if overlaps_with?(accrual)
        no_overlap = false
        break
      end
    end

    errors.add(:base, "The date range you selected conflicts with an existing accrual.") unless no_overlap
    no_overlap
  end

  private

  def overlaps_with?(accrual)
    (start_year - accrual.end_year) * (accrual.start_year - end_year) > 0
  end
end
