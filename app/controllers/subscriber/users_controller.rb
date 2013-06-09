class Subscriber::UsersController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  def update
    @user = current_user.subscriber.users.find(params[:id])
    @user.update(join_date: join_date)
    respond_with_bip(@user)
  end

  def destroy
    @user = current_user.subscriber.users.find(params[:id])
    if @user.destroy
      redirect_to subscribers_url, notice: "#{@user.display_name} was deleted from your account."
    else
      redirect_to subscribers_url, alert: "#{@user.errors.full_messages.first}"
    end
  end

  private

  def user_params
    params.require(:user).permit(:join_date)
  end

  def join_date
    if user_params[:join_date].include?("/")
      formatted_date
    else
      user_params[:join_date]
    end
  end

  def split_slash_date
    user_params[:join_date].split("/").map(&:to_i)
  end

  def formatted_date
    split = split_slash_date
    Date.new(split[2], split[0], split[1])
  end
end
