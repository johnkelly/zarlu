class HomesController < ApplicationController
  before_filter :authenticate_user!, only: %w[show]
  before_filter :authenticate_paid_account!, only: %w[show]

  def index
  end

  def show

  end

  def pricing
  end
end
