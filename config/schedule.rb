# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

require './app/services/collect_garbage'

every CollectGarbage::LIFETIME do
  runner 'CollectGarbageJob.perform_later'
end
