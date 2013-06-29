class HomesController < ApplicationController
  before_action :authenticate_user!, only: %w[show]
  before_action :check_if_trial_or_cc!, only: %w[show]

  etag { [current_user, flash] }

  def index
    fresh_when("homes_index")
  end

  def show
    @subscriber = current_user.subscriber
    @available_events = @subscriber.available_events
    @calendar_type = params[:calendar_type] || "user"
    fresh_when([@subscriber, @calendar_type])
  end

  def pricing
    fresh_when("homes_pricing")
  end

  def privacy
    fresh_when("homes_privacy")
  end

  def features
    fresh_when("homes_features")
  end

  def terms_of_service
    fresh_when("homes_terms_of_service")
  end
end
