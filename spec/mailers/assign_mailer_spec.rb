require "rails_helper"

include ActiveJob::TestHelper
ActiveJob::Base.queue_adapter = :test

RSpec.describe AssignMailer, type: :mailer do

  let(:user){ User.create(email: 'hi@hi.com') }

 # emails = FactoryBot.create_list(:user,3).pluck(:email, :fullname)
  course = FactoryBot.create :course

  it "send email to sidekiq" do
    expect{
      AssignMailer.sendMailMembers(user.email, course.id, "TEST").deliver_later
    }.to have_enqueued_job.on_queue('mailers')
  end

  it "mail sent" do
    expect {
      perform_enqueued_jobs do
        AssignMailer.sendMailMembers(user.email, course.id, "TEST").deliver_later
      end
    }.to change { ActionMailer::Base.deliveries.size }.by(1)
  end

  it " sent to the right user" do
    perform_enqueued_jobs do
      AssignMailer.sendMailMembers(user.email, course.id, "TEST").deliver_later
    end

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq user.email
  end
end
