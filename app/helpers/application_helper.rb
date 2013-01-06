module ApplicationHelper

  def banner_link_in_nav
    user_signed_in? ? home_path : root_path
  end

  def display_banner
    "#{link_to "Zarlu", banner_link_in_nav, id: "logo", data: { "no-turbolink" => true }}".html_safe
  end
end
