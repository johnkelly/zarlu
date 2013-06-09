class RegistrationsController < Devise::RegistrationsController
 before_action :configure_permitted_parameters, only: :update

  def create
    self.resource = build_resource(sign_up_params)

    resource.subscriber = Subscriber.create!
    resource.manager = true

    if resource.save
      if resource.active_for_authentication?
        sign_up_success(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      sign_up_failure(resource)
    end
  end

  def destroy
    if resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed if is_navigational_format?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      redirect_to edit_user_registration_url, alert: resource.errors.full_messages.first
    end
  end

  protected

  def after_sign_up_path_for(resource)
    welcome_path
  end

  def after_update_path_for(resource)
    resource.manager? ? welcome_path : employee_welcome_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :name) }
  end

  private

  def sign_up_success_but_inactive(resource)
    set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
    expire_session_data_after_sign_in!
    respond_with resource, location: after_inactive_sign_up_path_for(resource)
  end

  def sign_up_success(resource)
    set_flash_message :notice, :signed_up if is_navigational_format?
    flash[:analytics] = "/vp/create_account"
    sign_up(resource_name, resource)
    track_activity!(resource)
    respond_with resource, location: after_sign_up_path_for(resource)
  end

  def sign_up_failure(resource)
    clean_up_passwords resource
    flash.now[:alert] = resource.errors.full_messages.first
    respond_with resource
  end
end
