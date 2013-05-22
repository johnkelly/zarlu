class EmployeeWelcomesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def show
  end
end
