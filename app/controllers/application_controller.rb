class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    home_path
  end

  def authenticate_manager!
    raise ActiveRecord::RecordNotFound unless authenticate_user! && current_user.manager?
  end
end
