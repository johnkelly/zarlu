class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @subscriber = current_user.subscriber
    @subscriber.update_attributes(params[:subscriber])
    redirect_to subscriptions_url
  end

  def show
    @subscriber = current_user.subscriber
  end
end
