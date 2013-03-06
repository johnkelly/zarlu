module WelcomeHelper
  def display_welcome_tour_task(user)
    if user.completed_welcome_tour?
      check_box_tag 'welcome_tour_task', 'complete', true, disabled: true
    else
      check_box_tag 'welcome_tour_task', 'complete', false, disabled: true
    end
  end

  def display_add_co_worker_task(user)
    if subscriber_users(user).count > 1
      check_box_tag 'add_user_task', 'complete', true, disabled: true
    else
      check_box_tag 'add_user_task', 'complete', false, disabled: true
    end
  end

  def display_add_time_off_task(user)
    if at_least_one_time_off_request(user)
      check_box_tag 'time_off_task', 'complete', true, disabled: true
    else
      check_box_tag 'time_off_task', 'complete', false, disabled: true
    end
  end

  def display_assign_employee_task(user)
    if at_least_one_assigned_employee(user)
      check_box_tag 'assign_employee_task', 'complete', true, disabled: true
    else
      check_box_tag 'assign_employee_task', 'complete', false, disabled: true
    end
  end

  def display_add_paid_plan_task(user)
    if user.subscriber.paid_plan?
      check_box_tag 'add_paid_plan_task', 'complete', true, disabled: true
    else
      check_box_tag 'add_paid_plan_task', 'complete', false, disabled: true
    end
  end

  private

  def at_least_one_assigned_employee(user)
    subscriber_users(user).detect { |u| u.manager_id.present? }
  end

  def at_least_one_time_off_request(user)
    Event.where(user_id: subscriber_users(user)).limit(1).present?
  end

  def subscriber_users(user)
    user.subscriber.users
  end
end
