class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :redirect_root_to_www

  def after_sign_in_path_for(resource)
    activities_path
  end

  def authenticate_manager!
    raise ActiveRecord::RecordNotFound unless authenticate_user! && current_user.manager?
  end

  def authenticate_paid_account!
    if current_user.subscriber.plan != "coach" && current_user.subscriber.customer_token.blank?
      return redirect_to subscriptions_url, alert: "Paid accounts must have a credit card. Please add a credit card to use Zarlu."
    end
  end

  def track_activity!(trackable, action = params[:action])
    current_user.activities.create! action: action, trackable: trackable
  end

  private

  def redirect_root_to_www
    if Rails.env.production? && request.subdomain.blank?
      redirect_to request.protocol + 'www.zarlu.com' + request.fullpath, status: 301
    end
  end
end
