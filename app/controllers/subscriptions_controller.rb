class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  etag { [current_user, flash] }

  def update
    @subscriber = current_user.subscriber
    @subscriber.card_token = card_token(params)

    if token_present?(@subscriber) && @subscriber.save_credit_card(current_user, coupon) && @subscriber.save
      redirect_to subscriptions_url, notice: display_success_message
    else
      flash.now[:alert] = "There was a problem with your credit card. If you believe you entered your information correctly, please try again or contact support."
      render :show
    end
  end

  def show
    @subscriber = current_user.subscriber
    @user_count = @subscriber.users.count
    fresh_when([@subscriber, @user_count])
  end

  private

  def card_token(params)
    params[:subscriber].delete("card_token")
  end

  def token_present?(subscriber)
    subscriber.card_token.present?
  end

  def coupon
    @coupon ||= params[:subscriber].delete("coupon")
  end

  def display_success_message
    if coupon.present?
      "ERLIBIRD discount applied for $50 off your subscription for 3 months. A $150 value!"
    else
      "Successfully updated your company's credit card."
    end
  end
end
