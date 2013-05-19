class SubscribersController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!
  before_action :shared_variables

  def show
    @time_off_view = params[:time_off_view].presence || "time_off_used"
    @user = User.new
    @employees = @users.sort_by(&:display_name)
    @events = Event.where(user_id: @subscriber.users)
    @managers = @subscriber.managers(@users).sort_by(&:display_name)
    @manager_collection = manager_collection
  end

  def update
    @subscriber = current_user.subscriber
    @subscriber.update!(subscriber_params)
    respond_with_bip(@subscriber)
  end

  def add_user
    @user = @users.new(user_params)
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

  def demote_to_employee
    @user = @users.find(params[:user_id])
    if @subscriber.managers(@users).count == 1
      flash[:alert] = "Zarlu requires customers to have at least one manager so that someone in your company can view administrative pages."
    else
      @user.demote_to_employee!
      flash[:notice] = %Q{Demoted #{@user.display_name} to employee.}
    end
    redirect_to subscribers_url
  end

  def change_manager
    @user = @users.find(params[:user_id])
    @user.change_manager!(params[:user][:manager_id].to_i)
    respond_with_bip(@user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def subscriber_params
    params.require(:subscriber).permit(:name, :time_zone)
  end

  def charge_credit_card(subscriber)
    ChargeCreditCardWorker.perform_async(subscriber.id) unless subscriber.trial?
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
