class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :plan, :card_token

  validates :plan, presence: true, inclusion: { in: %w(coach business business_select first_class) }

  attr_accessor :card_token

  PLANS = {
    "Coach $0 / month" => "coach",
    "Business $50 / month" => "business",
    "Business Select $100 / month" => "business_select",
    "First Class $150 / month" => "first_class"
  }

  def plan_users
    case plan
    when "coach"
      2
    when "business"
      30
    when "business_select"
      75
    when "first_class"
      150
    end
  end

  def plan_cost
    case plan
    when "coach"
      0
    when "business"
      50
    when "business_select"
      100
    when "first_class"
      150
    end
  end

  def under_user_limit_for_plan
    users.count < plan_users
  end

  def no_manager_assigned(users)
    users.select { |user| user.manager_id == nil }
  end

  def managers(users)
    users.select { |user| user.manager == true }
  end
end
