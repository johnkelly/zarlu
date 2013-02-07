class IncomingMailsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    message = params[:plain]
    date = format_date(date_from_subject(params[:headers][:Subject]))
    user = User.where(email: params[:headers][:From]).first

    if user.present?
      @event = user.events.create!(title: "Time off", description: message, starts_at: date, ends_at: date, all_day: true)
      render text: 'success', status: 200
    else
      Rails.logger.info "Email Rejected: #{params[:headers][:From]} is not a user"
      render text: 'The email address you sent this email from is not registered at Zarlu', status: 404
    end
  end

  private

  def date_from_subject(subject)
    subject.scan(/\d{1,2}\/?-?\d{1,2}\/?-?\d{2,4}/).first.split(/\/|-/)
  end

  def format_date(splitted_date)
    "#{splitted_date[2]}/#{splitted_date[0]}/#{splitted_date[1]}".to_date
  end
end
