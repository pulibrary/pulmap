# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every :day, at: "11:00 PM", roles: [:db] do
  rake "gblsci:images:harvest_retry"
end
