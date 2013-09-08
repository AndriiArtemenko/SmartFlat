class DefaultMailer < ActionMailer::Base
  DEFAULT_FROM = 'smartflat48@gmail.com'

  # Send email accordingly to setup_mail.rb config.
  def send_email(address, subject, body)
    mail(to:      address,
         from:    DEFAULT_FROM,
         subject: subject,
         body:    body).deliver
  end
end
