class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    home_path
  end

  def authenticate_manager!
    raise ActiveRecord::RecordNotFound unless authenticate_user! && current_user.manager?
  end

  def authenticate_paid_account!
    if current_user.subscriber.plan != "coach" && current_user.subscriber.customer_token.blank?
      return redirect_to subscriptions_url, alert: "Paid accounts must have a credit card. Please add a credit card to use Zarlu."
    end
  end
end
