class SubscribersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @subscriber = current_user.subscriber
    @users = @subscriber.users
    @user = User.new
  end
end
