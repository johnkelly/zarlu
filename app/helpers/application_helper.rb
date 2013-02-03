module ApplicationHelper
  def banner_link_in_nav
    user_signed_in? ? home_path : root_path
  end

  def display_banner
    "#{link_to "Zarlu", banner_link_in_nav, id: "logo"}".html_safe
  end

  def display_manager_for_user
    manager_id = current_user.manager_id
    if manager_id.present?
      "<i>#{User.find(manager_id).email.capitalize} approves my schedule</i>".html_safe
    end
  end
end
