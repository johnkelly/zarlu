class UserMailer < ActionMailer::Base
  default from: "John From Zarlu <john@zarlu.com>"

  def new_account(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Help getting started?")
    Rails.logger.info "New Account email Sent Via Mandrill"
  end
end
