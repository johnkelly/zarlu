class WelcomesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def create
    update_user_property
    current_user.save!
    head :ok
  end

  def show

  end

  private

  def update_user_property
    if params[:support].present?
      current_user.open_support_tool = "true"
    else
      current_user.complete_welcome_tour = "true"
    end
  end
end
