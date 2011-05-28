ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => "587",
  :authentication => :plain,
  :user_name => CFG[:mail][:address],
  :password => CFG[:mail][:password],
  :enable_starttls_auto => true
}

# send development mails to developers
if Rails.env.development?
  class DevelopmentMailInterceptor
    def self.delivering_email(message)
      message.subject = "#{message.to} #{message.subject}"
      message.to = CFG[:mail][:test_recipient]
    end
  end

  Mail.register_interceptor(DevelopmentMailInterceptor)
end
