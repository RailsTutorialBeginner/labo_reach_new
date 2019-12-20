require 'test_helper'

class StudentMailerTest < ActionMailer::TestCase
  test "student_account_activation" do
    mail = StudentMailer.student_account_activation
    assert_equal "Student account activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "student_password_reset" do
    mail = StudentMailer.student_password_reset
    assert_equal "Student password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
