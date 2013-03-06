class WelcomesController < ApplicationController
  before_filter :authenticate_user!, only: %w[show create]
  before_filter :authenticate_paid_account!, only: %w[show create]

  def create
    current_user.complete_welcome_tour = "true"
    current_user.save!
    head :ok
  end

  def show

  end
end
