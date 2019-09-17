#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, :development
set :output, { error: "log/cron_error_log.log", standard: "log/cron_log.log"}
every 1.month - 1.day, at: "5:00 pm" do
  rake "mails_monthly:mails_monthly"
end
