class WelcomesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def create
    current_user.complete_welcome_tour = "true"
    current_user.save!
    head :ok
  end

  def show

  end
end
