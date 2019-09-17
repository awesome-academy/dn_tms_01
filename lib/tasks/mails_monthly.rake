namespace :mails_monthly do
  desc "mails_monthly"
    task mails_monthly: :environment do
      SendEmailEndOfMonthMailer.send_mail
  end
end
