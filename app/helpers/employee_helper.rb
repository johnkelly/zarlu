module EmployeeHelper
  def display_logs_or_charts(display)
    if display == "logs"
      render partial: "employees/logs"
    else
      render partial: "employees/charts"
    end
  end
end
