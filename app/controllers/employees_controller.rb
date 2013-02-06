class EmployeesController < ApplicationController
  before_filter :authenticate_manager!

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
      redirect_to employees_url, notice: "Approved."
    when "reject"
      @my_employee_pending_event.reject!
      redirect_to employees_url, notice: "Rejected."
    end
  end
end
