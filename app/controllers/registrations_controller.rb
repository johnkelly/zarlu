class RegistrationsController < Devise::RegistrationsController

  def new
    @plan = params[:plan].presence || "coach"
    super
  end
end