module SubscriberHelper
  def display_manager(manager)
    if manager.present?
      html = image_tag gravatar_url(manager), width: 30, height: 30, alt: "avatar", class: "img-circle"
      html += "&nbsp;<span class='v-align-middle'>#{manager.display_name}</span>".html_safe
    else
      html = "None"
    end
    html
  end

  def display_employee(employee)
    html = image_tag gravatar_url(employee), width: 30, height: 30, alt: "avatar", class: "img-circle"
    html += "&nbsp;<span class='v-align-middle'>#{employee.display_name}</span>".html_safe
    html
  end
end