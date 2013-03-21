class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  attr_accessible :plan

  validates_inclusion_of :plan, in: %w(public_paid_plan), allow_blank: true

  attr_accessor :card_token

  def save_credit_card
    if valid?
      if has_credit_card?
        change_credit_card
      else
        add_credit_card
      end
    else
      false
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe error while subscribing customer: #{e.message}"
    self.card_token = nil
    false
  end

  def under_user_limit_for_free_plan
    users.count < 10
  end

  def has_credit_card?
    customer_token.present?
  end

  def paid_plan?
    plan.present?
  end

  def no_manager_assigned(users)
    users.select { |user| user.manager_id == nil }
  end

  def managers(users)
    users.select { |user| user.manager == true }
  end

  def add_or_update_subscription
    if users.count > 10
      customer = Stripe::Customer.retrieve(customer_token)
      customer.update_subscription(plan: "public_paid_plan", quantity: paid_subscription_quantity)
    end
  end

  private

  def add_credit_card
    customer = Stripe::Customer.create(description: "Subscriber: #{id}", card: card_token)
    self.customer_token = customer.id
    store_card_info(customer.active_card)
    true
  end

  def change_credit_card
    customer = Stripe::Customer.retrieve(customer_token)
    customer.card = card_token
    customer.save
    store_card_info(customer.active_card)
    true
  end

  def store_card_info(card)
    self.card_last4 = card.last4
    self.card_type = card.type
  end

  def paid_subscription_quantity
    users.count - 10
  end
end
