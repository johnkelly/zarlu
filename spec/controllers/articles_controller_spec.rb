require 'spec_helper'

describe ArticlesController do
  describe "employee_leave_management" do
    before { get :employee_leave_management }
    it { should respond_with(:success) }
  end

  describe "employee_attendance_calendar" do
    before { get :employee_attendance_calendar }
    it { should respond_with(:success) }
  end

  describe "business_time_tracking" do
    before { get :business_time_tracking }
    it { should respond_with(:success) }
  end
end
