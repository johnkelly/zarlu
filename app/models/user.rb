class User < ActiveRecord::Base
  belongs_to :subscriber
  has_many :events, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :leaves, dependent: :destroy
  has_one :vacation_leave, dependent: :destroy, class_name: "VacationLeave", foreign_key: :user_id
  has_one :sick_leave, dependent: :destroy, class_name: "SickLeave", foreign_key: :user_id
  has_one :personal_leave, dependent: :destroy, class_name: "PersonalLeave", foreign_key: :user_id
  has_one :unpaid_leave, dependent: :destroy, class_name: "UnpaidLeave", foreign_key: :user_id
  has_one :other_leave, dependent: :destroy, class_name: "OtherLeave", foreign_key: :user_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :subscriber_id

  store :properties, accessors: [:complete_welcome_tour, :open_support_tool]

  before_create :create_leave
  before_destroy :check_deletion_and_demote_to_employee!, if: Proc.new {|user| user.manager? }
  after_destroy :stop_charging_subscriber

  def promote_to_manager!
    self.update!(manager: true)
  end

  def demote_to_employee!
    set_employee_manager_id_to_none
    self.update!(manager: false)
  end

  def employees
    User.where(manager_id: id)
  end

  def has_manager?
    manager_id.present?
  end

  def completed_welcome_tour?
    complete_welcome_tour.present?
  end

  def open_support_tool?
    open_support_tool.present?
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

  def display_join_date
    join_date.strftime("%m/%d/%Y")
  end

  def first_sign_in?
    sign_in_count <= 1
  end

  def years_at_company
    (days_at_company / 365.0).round(1)
  end

  def accrual_rate(type)
    Accrual.find_rate(subscriber, type, years_at_company)
  end

  private

  def set_employee_manager_id_to_none
    employees.each { |employee| employee.change_manager!(-1) }
  end

  def create_leave
    build_vacation_leave
    build_sick_leave
    build_personal_leave
    build_unpaid_leave
    build_other_leave
  end

  def stop_charging_subscriber
    ChargeCreditCardWorker.perform_async(subscriber_id)
  end

  def check_deletion_and_demote_to_employee!
    if delete_manager?
      demote_to_employee!
      true
    else
      errors.add(:base, "You must delete all non managers or add a new manager before removing your last manager account.")
      false
    end
  end

  def delete_manager?
    more_than_one_manager? || no_employees?
  end

  def more_than_one_manager?
    subscriber.users.where(manager: true).count > 1
  end

  def no_employees?
    subscriber.users.where(manager: false).count == 0
  end

  def days_at_company
    if join_date.present?
      Date.current - join_date
    else
      0
    end
  end
end
