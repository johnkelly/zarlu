class SubscribersController < ApplicationController
  before_filter :authenticate_manager!
  before_filter :authenticate_paid_account!
  before_filter :shared_variables

  respond_to :json, only: %w[update]

  def show
    @user = User.new
    @employees = @users.sort_by(&:display_name)
    @events = Event.where(user_id: @subscriber.users)
    @managers = @subscriber.managers(@users).sort_by(&:display_name)
    @manager_collection = manager_collection
  end

  def add_user
    @user = @users.new(params[:user])
    if @user.save
      charge_credit_card(@subscriber)
      track_activity!(@user)
      redirect_to subscribers_url, notice: %Q{Successfully created new user.}
    else
      redirect_to subscribers_url, alert: @user.errors.full_messages.first
    end
  end

  def promote_to_manager
    @user = @users.find(params[:user_id])
    @user.promote_to_manager!
    track_activity!(@user)
    redirect_to subscribers_url, notice: %Q{Promoted #{@user.display_name} to manager.}
  end

  def change_manager
    @user = @users.find(params[:user_id])
    @user.change_manager!(params[:user][:manager_id].to_i)
    respond_with_bip(@user)
  end

  private

  def charge_credit_card(subscriber)
    if subscriber.users.count > 10
      ChargeCreditCardWorker.perform_async(subscriber.id)
    end
  end

  def shared_variables
    @subscriber = current_user.subscriber
    @users = @subscriber.users
  end

  def manager_collection
    manager_collection = @managers.map { |m| [m.id, m.display_name] }
    manager_collection.unshift([-1, "None"])
    manager_collection
  end
end
