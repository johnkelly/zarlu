class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :redirect_root_to_www

  def after_sign_in_path_for(resource)
    activities_path
  end

  def authenticate_manager!
    raise ActiveRecord::RecordNotFound unless authenticate_user! && current_user.manager?
  end

  def check_if_trial_or_cc!
    unless current_user.subscriber.has_credit_card? || current_user.subscriber.trial?
      return redirect_to subscriptions_url, alert: "Your 30 day trial has expired. Please add your credit card to continue using Zarlu. Feel free to contact us with any questions you may have."
    end
  end

  def track_activity!(trackable, action = params[:action])
    ActivityWorker.perform_async(current_user.id, action, trackable.class.to_s, trackable.id)
  end

  private

  def redirect_root_to_www
    if Rails.env.production? && request.subdomain.blank?
      redirect_to request.protocol + 'www.zarlu.com' + request.fullpath, status: 301
    end
  end
end
