class User < ActiveRecord::Base
  belongs_to :subscriber
  has_many :events, dependent: :destroy
  has_many :activities, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscriber_id, :manager_id, :manager

  validates_presence_of :subscriber_id
  validate :valid_number_of_users, on: :create

  store :properties, accessors: [:complete_welcome_tour]

  def promote_to_manager!
    self.manager = true
    self.save!
  end

  def employees
    User.where(manager_id: self.id)
  end

  def has_manager?
    manager_id.present?
  end

  def completed_welcome_tour?
    complete_welcome_tour.present?
  end

  private

  def valid_number_of_users
    unless subscriber.try(:under_user_limit_for_free_plan) || subscriber.try(:has_credit_card?)
      errors.add(:base, %Q{You have reached the free plan limit of 10 employees / managers. Add your business' credit card by clicking on [Settings -> Change / View Billing Info] on the top navigation bar to upgrade your business to a paid plan.})
      false
    end
  end
end
