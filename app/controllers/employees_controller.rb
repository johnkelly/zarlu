class EmployeesController < ApplicationController
  before_action :authenticate_manager!
  before_action :check_if_trial_or_cc!

  def index
    @my_employees = current_user.employees
    @my_employee_pending_events = Event.where(user_id: @my_employees, approved: false, rejected: false)
  end

  def update
    @my_employees = current_user.employees
    @my_employee_pending_event = Event.where(user_id: @my_employees, approved: false, rejected: false).find(params[:id])

    case params[:type]
    when "approve"
      @my_employee_pending_event.approve!
      track_activity!(@my_employee_pending_event, "approve")
      redirect_to employees_url, notice: "Approved."
    when "reject"
      @my_employee_pending_event.reject!
      track_activity!(@my_employee_pending_event, "reject")
      redirect_to employees_url, notice: "Rejected."
    end
  end

  def show
    @display = params[:charts].presence || "logs"
    @employee = current_user.subscriber.users.find(params[:id])
    @subscriber = @employee.subscriber
    @manager = @employee.has_manager? ? User.find(@employee.manager_id).display_name : "No Manager Assigned"
    @events = @employee.events.lifo
    @event_durations = EventDurationService.new(@events)
  end
end
