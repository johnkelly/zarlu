class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_paid_account!

  def index
    @level_of_activity = params[:activity_type].presence || "user"
    subscriber = current_user.subscriber
    @managers = subscriber.managers(subscriber.users)
    case @level_of_activity
    when "user"
      @activities = current_user.activities.order("created_at desc").limit(50).includes(:user)
    when "manager"
      employees = current_user.employees.collect(&:id)
      @activities = Activity.order("created_at desc").where(user_id: employees).limit(50).includes(:user)
    when "company"
      company = current_user.subscriber.users.collect(&:id)
      @activities = Activity.order("created_at desc").where(user_id: company).limit(50).includes(:user)
    end
  end
end
