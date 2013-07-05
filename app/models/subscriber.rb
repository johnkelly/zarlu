class Subscriber < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :company_settings, dependent: :destroy
  has_many :accruals, dependent: :destroy
  has_many :vacation_accruals, class_name: "VacationAccrual", foreign_key: :subscriber_id
  has_many :sick_accruals, class_name: "SickAccrual", foreign_key: :subscriber_id
  has_many :personal_accruals, class_name: "PersonalAccrual", foreign_key: :subscriber_id
  has_many :unpaid_accruals, class_name: "UnpaidAccrual", foreign_key: :subscriber_id
  has_many :other_accruals, class_name: "OtherAccrual", foreign_key: :subscriber_id
  has_many :holidays, dependent: :destroy
  has_one :vacation_company_setting, class_name: "VacationCompanySetting", foreign_key: :subscriber_id
  has_one :sick_company_setting, class_name: "SickCompanySetting", foreign_key: :subscriber_id
  has_one :personal_company_setting, class_name: "PersonalCompanySetting", foreign_key: :subscriber_id
  has_one :unpaid_company_setting, class_name: "UnpaidCompanySetting", foreign_key: :subscriber_id
  has_one :other_company_setting, class_name: "OtherCompanySetting", foreign_key: :subscriber_id

  attr_accessor :card_token

  before_create :create_settings

  TRIAL_PERIOD = 30.days

  def self.expired_yesterday_with_credit_card
    select { |s| s.expired_yesterday? && s.has_credit_card? }
  end

  def save_credit_card(user)
    if valid?
      if has_credit_card?
        change_credit_card
      else
        add_credit_card(user)
      end
    else
      false
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe error while subscribing customer: #{e.message}"
    self.card_token = nil
    false
  end

  def has_credit_card?
    customer_token.present?
  end

  def no_manager_assigned(users)
    users.select { |user| user.manager_id == nil }
  end

  def managers(users)
    users.select { |user| user.manager == true }
  end

  def update_subscription_users
    customer = Stripe::Customer.retrieve(customer_token)
    customer.update_subscription(plan: "public_paid_plan", quantity: users.count)
  end

  def available_events
    company_settings.select(&:enabled?).map(&:kind).sort_by{ |a| a[1] }
  end

  def trial?
    last_trial_day >= Time.now
  end

  def last_trial_day
    created_at + TRIAL_PERIOD
  end

  def expired_yesterday?
    last_trial_day.to_date == 24.hours.ago.to_date
  end

  private

  def add_credit_card(user)
    customer = create_customer(user)
    self.customer_token = customer.id
    store_card_info(customer.active_card)
    true
  end

  def create_customer(user)
    trial? ? create_customer_with_trial(user) : create_customer_without_trial(user)
  end

  def create_customer_with_trial(user)
    Stripe::Customer.create(email: user.email,
                            description: "Subscriber: #{id}",
                            card: card_token,
                            plan: "public_paid_plan",
                            trial_end: last_trial_day.to_i,
                            quantity: users.count)
  end

  def create_customer_without_trial(user)
    Stripe::Customer.create(email: user.email,
                            description: "Subscriber: #{id}",
                            card: card_token,
                            plan: "public_paid_plan",
                            quantity: users.count)
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

  def create_settings
    build_vacation_company_setting
    build_sick_company_setting
    build_personal_company_setting
    build_unpaid_company_setting
    build_other_company_setting
  end
end
