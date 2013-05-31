class BlogController < ApplicationController
  def post
    filter_invalid_titles
    render "/#{self.controller_name}/#{params[:title]}/index.html"
  end

  private

  def filter_invalid_titles
    raise ActiveRecord::RecordNotFound unless current_blog_titles.include?(params[:title])
  end

  def current_blog_titles
    %w[
      improved-employee-management
      employee-time-management
      business-software
      tracking-employee-attendance
      importance-of-using-a-time-attendance-program
      human-resources-software-analysis
      employee-scheduling-software
      employee-attendance
      introducing-the-activity-feed
      10-countries-with-the-most-employee-time-off
      types-of-employee-time-off
      common-employee-vacation-time-off-holidays
      when-to-take-sick-days
      pros-and-cons-of-unlimited-time-off-policies
      overcoming-peer-pressure-to-not-take-vacations
      best-time-off-tracking-software
      zarlu-employee-calendar-and-scheduler-goes-live
      how-does-zarlu-keep-my-data-safe
    ]
  end
end
