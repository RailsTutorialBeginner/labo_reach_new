class StudentMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.student_mailer.student_account_activation.subject
  #
  def student_account_activation(student)
    @student = student
    mail to: student.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.student_mailer.student_password_reset.subject
  #
  def student_password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
