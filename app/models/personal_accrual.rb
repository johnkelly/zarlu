class PersonalAccrual < Accrual
  belongs_to :subscriber, touch: true

  validates_presence_of :type
end


