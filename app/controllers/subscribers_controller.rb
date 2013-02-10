class SubscribersController < ApplicationController
  before_filter :authenticate_manager!
  before_filter :authenticate_paid_account!
  before_filter :shared_variables

  def show
    @user = User.new
    @managers = @subscriber.managers(@users)
    @no_manager_users = @subscriber.no_manager_assigned(@users)
  end

  def add_user
    @user = @subscriber.users.new(params[:user])
    if @user.save
      redirect_to subscribers_url, notice: %Q{Successfully created new user.}
    else
      redirect_to subscribers_url, alert: @user.errors.full_messages.first
    end
  end

  def promote_to_manager
    @user = @subscriber.users.find(params[:user_id])
    @user.promote_to_manager!
    redirect_to subscribers_url, notice: %Q{Promoted #{@user.email} to manager.}
  end

  def change_manager
    @user = @subscriber.users.find(params[:user_id])

    if params[:manager_id] == "nil"
      @user.manager_id = nil
    else
      @manager = @subscriber.users.where(manager: true).find(params[:manager_id])
      @user.manager_id = @manager.id
    end

    @user.save!
    head :ok
  end

  private

  def shared_variables
    @subscriber = current_user.subscriber
    @users = @subscriber.users.select(&:persisted?)
  end
end
