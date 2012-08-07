require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "welcome" do
    mail = Notifier.welcome(users(:jef))
    assert_equal I18n.t("notifier.welcome.subject"), mail.subject
    assert_equal ["jef@jef.com"], mail.to
    assert_equal ["talkworking@gmail.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

  test "resend_password" do
    mail = Notifier.resend_password
    #assert_equal "Resend password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["talkworking@gmail.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

  test "invite_a_friend" do
    mail = Notifier.invite_a_friend(users(:jef), "secret", users(:leonardo), projects(:talkworking))
    assert_equal I18n.t("notifier.invite_a_friend.subject"), mail.subject
    assert_equal ["jef@jef.com"], mail.to
    assert_equal ["talkworking@gmail.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end
