class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def index
    @level_of_activity = params[:activity_type].presence || "user"
    @subscriber = current_user.subscriber
    @managers = @subscriber.managers(@subscriber.users)
    @activities = Activity.where(user_id: users).lifo.includes(:user).paginate(page: params[:page], per_page: 30)
  end

  private

  def users
    case @level_of_activity
    when "user"
      current_user.id
    when "manager"
      current_user.employees.map(&:id)
    when "company"
      @subscriber.users.map(&:id)
    end
  end
end
