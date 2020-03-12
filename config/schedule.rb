# frozen_string_literal: true

# Set path. See: https://github.com/javan/whenever/issues/542
env :PATH, ENV['PATH']

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Run a daily rake task to harvest new thumbnail images.
# These could be from new records or from records
# where there was a previous error during harvesting.
every :day, at: "11:00 PM", roles: [:db] do
  rake "gblsci:images:harvest_new"
end

# Run a weekly rake task to harvest thumbnail in incomplete states.
# These could be from new records or from records
# where there was a previous error during harvesting.
every :saturday, at: "11:00 AM", roles: [:db] do
  rake "gblsci:images:harvest_retry"
end
