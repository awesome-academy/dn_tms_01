class SendInfoCourseToSupMailer < ApplicationMailer

  def self.send_mail course
    supervisors = User.supervisor.pluck(:email, :fullname)
    supervisors.each do |email|
      sendMailToSup(email[0], course, email[1]).deliver
    end
  end

  def sendMailToSup email, course, name
    @name = name
    @course = course
    mail(to: email, subject: t("mailer.info.subject"))
  end
end
