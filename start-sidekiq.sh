#!/bin/sh

RUBYOPT='-W0' bundle exec whenever --update-crontab --set environment=development
service cron start
bundle exec sidekiq -C config/sidekiq.yml
