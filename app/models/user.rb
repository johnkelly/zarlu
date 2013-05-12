class User < ActiveRecord::Base
  belongs_to :subscriber
  has_many :events, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :leaves, dependent: :destroy
  has_one :vacation_leave, dependent: :destroy, class_name: "VacationLeave", foreign_key: :user_id
  has_one :sick_leave, dependent: :destroy, class_name: "SickLeave", foreign_key: :user_id
  has_one :holiday_leave, dependent: :destroy, class_name: "HolidayLeave", foreign_key: :user_id
  has_one :personal_leave, dependent: :destroy, class_name: "PersonalLeave", foreign_key: :user_id
  has_one :unpaid_leave, dependent: :destroy, class_name: "UnpaidLeave", foreign_key: :user_id
  has_one :other_leave, dependent: :destroy, class_name: "OtherLeave", foreign_key: :user_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :subscriber_id
  validate :valid_number_of_users, on: :create

  store :properties, accessors: [:complete_welcome_tour]

  before_create :create_leave

  def promote_to_manager!
    self.manager = true
    self.save!
  end

  def demote_to_employee!
    set_employee_manager_id_to_none
    self.manager = false
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

  def display_name
    name.try(:titleize).presence || email.capitalize
  end

  def change_manager!(manager_id)
    if manager_id == -1
      self.manager_id = nil
    else
      manager = subscriber.users.where(manager: true).find(manager_id)
      self.manager_id = manager.id
    end
    self.save!
  end

  private

  def valid_number_of_users
    unless subscriber.try(:under_user_limit_for_free_plan) || subscriber.try(:has_credit_card?)
      errors.add(:base, %Q{You have reached the free plan limit of 10 employees / managers. Add your business' credit card by clicking on [Settings -> Change / View Billing Info] on the top navigation bar to upgrade your business to a paid plan.})
      false
    end
  end

  def set_employee_manager_id_to_none
    employees.each { |employee| employee.change_manager!(-1) }
  end

  def create_leave
    build_vacation_leave
    build_sick_leave
    build_holiday_leave
    build_personal_leave
    build_unpaid_leave
    build_other_leave
  end
end
