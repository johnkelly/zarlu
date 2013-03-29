module ApplicationHelper
  def display_manager_for_user
    manager_id = current_user.manager_id
    if manager_id.present?
      "<i>#{User.find(manager_id).display_name} approves my schedule</i>".html_safe
    end
  end

  def display_card_info(subscriber)
    if subscriber.customer_token.present?
      "#{subscriber.card_type} XXXXXXXXXXXX#{subscriber.card_last4}"
    else
      "You have no credit card on file."
    end
  end

  def gravatar_url(user)
    "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}"
  end

  def disable_pill(user)
    user.manager? ? "" : "disabled nav_disabled"
  end
end
