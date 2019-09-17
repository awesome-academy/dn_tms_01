class SendEmailEndOfMonthMailer < ApplicationMailer
  def self.send_mail
    lists = CourseUser.includes(:user, :course).supervisor.pluck(:course_id, :user_id)
    result = {}

    lists.each do |item|
      if result.key? item[0]
        result[item[0]] << item[1]
       else
         result[item[0]] = [] << item[1]
       end
    end
    sendEveryEndOfMonth(result).deliver
  end

  def sendEveryEndOfMonth arg
    arg.each do |course_id, user_ids|
      @course = Course.find_by(id: course_id)
      @list_users = CourseUser.includes(:user).by_course_id course_id
      emails = User.byId(user_ids).pluck(:email)
      mail(to: emails, subject: t("mailer.end_of_month.subject") )
    end
  end

end
