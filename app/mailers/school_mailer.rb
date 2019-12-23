class SchoolMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.school_mailer.school_account_activation.subject
  #
  def school_account_activation(school)
    @school = school
    mail to: schoo.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.school_mailer.school_password_reset.subject
  #
  def school_password_reset
    @school = school
    mail to: school.email, subject: "Password reset"
  end
end
