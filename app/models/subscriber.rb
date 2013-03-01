class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :plan

  validates :plan, presence: true, inclusion: { in: %w(coach business business_select first_class) }

  attr_accessor :card_token

  PLANS = {
    "Coach $0 / month" => "coach",
    "Business $50 / month" => "business",
    "Business Select $100 / month" => "business_select",
    "First Class $150 / month" => "first_class"
  }

  def save_customer
    if valid?
      if customer_token.present?
        update_customer
      else
        create_customer
      end
    else
      false
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe error while subscribing customer: #{e.message}"
    self.card_token = nil
    false
  end

  def plan_users
    case plan
    when "coach"
      10
    when "business"
      40
    when "business_select"
      100
    when "first_class"
      175
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

  private

  def create_customer
    customer = Stripe::Customer.create(description: "Subscriber: #{id}", card: card_token, plan: plan)
    self.customer_token = customer.id
    store_card_info(customer.active_card)
    true
  end

  def update_customer
    customer = Stripe::Customer.retrieve(customer_token)
    customer.update_subscription(plan: plan, card: card_token)
    store_card_info(customer.active_card)
    true
  end

  def store_card_info(card)
    self.card_last4 = card.last4
    self.card_type = card.type
  end
end
