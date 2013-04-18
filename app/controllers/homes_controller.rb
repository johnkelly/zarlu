class HomesController < ApplicationController
  before_filter :authenticate_user!, only: %w[show]
  before_filter :authenticate_paid_account!, only: %w[show]

  def index
  end

  def show
    @calendar_type = params[:calendar_type] || "user"
  end

  def pricing
  end

  def privacy
  end
end
