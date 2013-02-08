class RegistrationsController < Devise::RegistrationsController

  def new
    @plan = params[:plan].presence || "coach"
    super
  end

  def create
    build_resource
    resource.subscriber = Subscriber.create!(plan: params[:plan])
    resource.manager = true

    if resource.save
      if resource.active_for_authentication?
        sign_up_success(resource)
      else
        sign_up_success_but_inactive(resource)
      end
    else
      sign_up_failure(resource)
    end
  end

  protected

  def after_sign_up_path_for(resource)
    subscribers_path
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
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_up_path_for(resource)
  end

  def sign_up_failure(resource)
    clean_up_passwords resource
    @plan = params[:plan]
    flash.now[:alert] = resource.errors.full_messages.first
    respond_with resource
  end
end
