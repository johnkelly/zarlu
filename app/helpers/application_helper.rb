module ApplicationHelper

  def banner_link_in_nav
    user_signed_in? ? home_path : root_path
  end
end
