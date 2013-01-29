class User < ActiveRecord::Base
  belongs_to :subscriber
  has_many :events, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscriber_id, :manager_id, :manager

  validates_presence_of :subscriber_id
  validate :valid_number_of_users, on: :create

  def promote_to_manager!
    self.manager = true
    self.save!
  end

  def employees
    User.where(manager_id: self.id)
  end

  private

  def valid_number_of_users
    unless subscriber.try(:under_user_limit_for_plan)
      errors.add(:base, %Q{You have reached your employee limit for your plan.  Upgrade your plan to add more employees})
      false
    end
  end
end
