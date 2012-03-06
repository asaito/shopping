# -*- encoding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default :from => "gs975318642@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notice.subject
  #
  def notice(cust)
    @greeting = "Hi"
    @name = cust.custname

    mail(:subject => "新着メール", :to => cust.email)
  end
end
