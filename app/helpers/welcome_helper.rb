module WelcomeHelper
  def display_welcome_tour_task(user)
    check_box_tag "welcome_tour_task", 'complete', user.completed_welcome_tour?, disabled: true
  end

  def display_add_co_worker_task(user)
    check_box_tag "add_user_task", 'complete', more_than_one_user?(user), disabled: true
  end

  def display_add_time_off_task(user)
    check_box_tag "time_off_task", 'complete', at_least_one_time_off_request?(user), disabled: true
  end

  def display_assign_employee_task(user)
    check_box_tag "assign_employee_task", 'complete', at_least_one_assigned_employee?(user), disabled: true
  end

  def display_add_paid_plan_task(user)
    check_box_tag "add_paid_plan_task", 'complete', user.subscriber.paid_plan?, disabled: true
  end

  private

  def more_than_one_user?(user)
    subscriber_users(user).count > 1
  end

  def at_least_one_assigned_employee?(user)
    subscriber_users(user).detect { |u| u.manager_id.present? }
  end

  def at_least_one_time_off_request?(user)
    Event.where(user_id: subscriber_users(user)).limit(1).present?
  end

  def subscriber_users(user)
    user.subscriber.users
  end
end
