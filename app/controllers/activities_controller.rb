class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_trial_or_cc!

  def index
    @level = params[:activity_type].presence || "user"
    @subscriber = current_user.subscriber
    @managers = @subscriber.managers(@subscriber.users)
    @activities = Activity.where(user_id: user_ids(@level, @subscriber)).lifo.includes(:user).paginate(page: params[:page], per_page: 30)
  end

  private

  def user_ids(level, subscriber)
    case level
    when "user"
      current_user.id
    when "manager"
      current_user.employees.map(&:id)
    when "company"
      subscriber.users.map(&:id)
    end
  end
end
