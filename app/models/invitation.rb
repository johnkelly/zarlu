class Invitation
  attr_reader :emails, :inviter

  def initialize(email_string, user)
    @emails = format_emails(email_string)
    @inviter = user
  end

  def mass_send
    emails.each do|email|
      User.invite!({ email: email, manager_id: inviter.id, subscriber_id: inviter.subscriber_id }, inviter)
    end
  end

  private

  def format_emails(email_string)
    email_string.split(/,/).reject(&:blank?).map{|email| email.gsub(/\s+/, "").strip }
  end
end
