class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def index
    @level_of_activity = params[:activity_type].presence || "user"
    @subscriber = current_user.subscriber
    @managers = @subscriber.managers(@subscriber.users)
    case @level_of_activity
    when "user"
      @activities = current_user.activities.order("created_at desc").includes(:user).paginate(page: params[:page], per_page: 30)
    when "manager"
      employees = current_user.employees.collect(&:id)
      @activities = Activity.order("created_at desc").where(user_id: employees).includes(:user).paginate(page: params[:page], per_page: 30)
    when "company"
      company = @subscriber.users.collect(&:id)
      @activities = Activity.order("created_at desc").where(user_id: company).includes(:user).paginate(page: params[:page], per_page: 30)
    end
  end
end
