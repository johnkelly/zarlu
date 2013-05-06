class HomesController < ApplicationController
  before_action :authenticate_user!, only: %w[show]
  before_action :authenticate_paid_account!, only: %w[show]

  def index
  end

  def show
    @available_events = current_user.subscriber.available_events
    @calendar_type = params[:calendar_type] || "user"
  end

  def pricing
  end

  def privacy
  end
end
