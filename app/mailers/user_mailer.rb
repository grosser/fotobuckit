class UserMailer < ActionMailer::Base
  default :from => CFG[:mail][:address]

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Registered")
  end
end
