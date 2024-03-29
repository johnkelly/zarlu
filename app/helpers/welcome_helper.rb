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

  def display_user_add_time_off(user)
    check_box_tag "user_time_off_task", 'complete', user.events.limit(1).present?, disabled: true
  end

  def display_add_credit_card_task(user)
    check_box_tag "add_credit_card_task", 'complete', user.subscriber.has_credit_card?, disabled: true
  end

  def display_add_company_name_task(user)
    check_box_tag "add_company_name_task", 'complete', user.subscriber.name.present?, disabled: true
  end

  def display_add_user_name_task(user)
    check_box_tag "add_user_name_task", 'complete', user.name.present?, disabled: true
  end

  def display_contact_support_task(user)
    check_box_tag "contact_support_task", 'complete', user.open_support_tool?, disabled: true
  end

  private

  def more_than_one_user?(user)
    subscriber_users(user).count > 1
  end

  def at_least_one_time_off_request?(user)
    Event.where(user_id: subscriber_users(user)).limit(1).present?
  end

  def subscriber_users(user)
    user.subscriber.users
  end
end
