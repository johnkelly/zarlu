class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @subscriber = current_user.subscriber
    @subscriber.card_token = card_token(params)

    if token_present?(@subscriber) && @subscriber.save_credit_card && @subscriber.save
      set_analytics_flash
      redirect_to subscriptions_url, notice: "Successfully updated your company's billing and/or plan."
    else
      flash.now[:alert] = "There was a problem with your credit card. If you believe you entered your information correctly, please try again or contact support."
      render :show
    end
  end

  def show
    @subscriber = current_user.subscriber
  end

  private

  def card_token(params)
    params[:subscriber].delete("card_token")
  end

  def token_present?(subscriber)
    subscriber.card_token.present?
  end

  def set_analytics_flash
    flash[:analytics] = "/vp/add_credit_card"
  end
end
