class SubscribersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :shared_variables

  def show
    @user = User.new
  end

  def add_user
    @user = @subscriber.users.new(params[:user])
    if @user.save
      redirect_to subscribers_url, notice: %Q{Successfully created new user.}
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :show
    end
  end

  private

  def shared_variables
    @subscriber = current_user.subscriber
    @users = @subscriber.users.select(&:persisted?)
  end
end
