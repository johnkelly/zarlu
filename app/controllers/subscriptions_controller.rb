class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @subscriber = current_user.subscriber
    @subscriber.card_token = card_token(params)
    @subscriber.plan = params[:subscriber][:plan]

    if plan_and_token_present?(@subscriber) && @subscriber.save_customer && @subscriber.save
      set_analytics_flash(@subscriber.plan)
      redirect_after_payment_url
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

  def plan_and_token_present?(subscriber)
    subscriber.card_token.present? && subscriber.plan.present?
  end

  def set_analytics_flash(plan)
    flash[:analytics] = "/vp/add_#{plan}_plan"
  end

  def redirect_after_payment_url
    if current_user.sign_in_count == 1
      redirect_to welcome_path, notice: "Successfully updated your company's billing and/or plan."
    else
      redirect_to subscriptions_url, notice: "Successfully updated your company's billing and/or plan."
    end
  end
end
