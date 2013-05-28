class EmployeeWelcomesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def show
    fresh_when([current_user, flash])
  end
end
