class WelcomesController < ApplicationController
  before_filter :authenticate_user!, only: %w[show]
  before_filter :authenticate_paid_account!, only: %w[show]

  def show

  end
end
