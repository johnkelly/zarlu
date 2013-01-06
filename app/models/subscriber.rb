class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :plan

  validates :plan, presence: true, inclusion: { in: %w(coach business business_select first_class) }

  def plan_users
    case plan
    when "coach"
      2
    when "business"
      25
    when "business_select"
      100
    when "first_class"
      200
    end
  end

  def under_user_limit_for_plan
    users.count < plan_users
  end
end
