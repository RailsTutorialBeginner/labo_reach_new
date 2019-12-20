# Preview all emails at http://localhost:3000/rails/mailers/student_mailer
class StudentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/student_mailer/student_account_activation
  def student_account_activation
    student = Student.first
    student.activation_token = Student.new_token
    StudentMailer.student_account_activation(student)
  end

  # Preview this email at http://localhost:3000/rails/mailers/student_mailer/student_password_reset
  def student_password_reset
    StudentMailer.student_password_reset
  end

end
