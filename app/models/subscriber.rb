class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :plan

  validates :plan, presence: true, inclusion: { in: %w(coach business business_select first_class) }
end
