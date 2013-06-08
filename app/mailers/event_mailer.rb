class EventMailer < ActionMailer::Base
  default from: "John From Zarlu <john@zarlu.com>"

  def pending(user_id)
    @user = User.find(user_id)
    @manager = User.find(@user.manager_id)
    mail(to: @manager.email, subject: "#{@user.display_name} has submitted time off for your approval")
    Rails.logger.info "Pending Email Sent Via Mandrill"
  end

  def approved(user_id)
    @user = User.find(user_id)
    if @user.has_manager?
      @manager = User.find(@user.manager_id)
      mail(to: @user.email, subject: "#{@manager.display_name} has approved your time off request")
      Rails.logger.info "Approved Email Sent Via Mandrill"
    end
  end

  def rejected(user_id)
    @user = User.find(user_id)
    if @user.has_manager?
      @manager = User.find(@user.manager_id)
      mail(to: @user.email, subject: "#{@manager.display_name} has rejected your time off request")
      Rails.logger.info "Rejected Email Sent Via Mandrill"
    end
  end
end
