class Notifier < ActionMailer::Base
  default :from => "talkworking@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.welcome.subject
  #
  def welcome(user)
    mail :to => user.email, :subject => I18n.t("notifier.welcome.subject")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.resend_password.subject
  #
  def resend_password
    @greeting = "Hi"

    mail :to =>  "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.invite_a_friend.subject
  #
  def invite_a_friend(user, password, inviter, project)
    @greeting = I18n.t('notifier.invite_a_friend.message', :inviter_name => inviter.email, :project_name => project.title, :password => password);
    mail :to => user.email, :subject => I18n.t("notifier.invite_a_friend.subject")
  end

  def associated_a_project(user, inviter, project)
    @greeting = I18n.t('notifier.associated_a_project.message', :inviter_name => inviter.email, :project_name => project.title);
    mail :to => user.email, :subject => I18n.t("notifier.associated_a_project.subject")
  end

end
