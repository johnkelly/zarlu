class IncomingMailsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    message = params[:plain]
    date = format_date(date_from_subject(params[:headers][:Subject]))
    user = User.where(email: email(params)).first

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

  def email(params)
    params[:headers][:From].downcase.scan(email_validation).first
  end

  def email_validation
    /[a-zA-Z0-9!\#$%&'*+\-\/=?^_`{|}~.]+@+[a-zA-Z0-9\-.]+.+[a-zA-Z0-9]/
  end
end
