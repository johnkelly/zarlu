class ArticlesController < ApplicationController
  etag { [current_user, flash] }

  def employee_leave_management
    fresh_when("articles_employee_leave_management")
  end

  def employee_attendance_calendar
    fresh_when("articles_employee_attendance_calendar")
  end

  def business_time_tracking
    fresh_when("articles_business_time_tracking")
  end
end
