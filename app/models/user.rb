class User < ActiveRecord::Base
  belongs_to :subscriber
  has_many :events, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :subscriber_id

  validates_presence_of :subscriber_id
  validate :valid_number_of_users

  private

  def valid_number_of_users
    unless subscriber.try(:under_user_limit_for_plan)
      errors.add(:base, %Q{You have reached your employee limit for your plan.  Upgrade your plan to add more employees})
      false
    end
  end
end
