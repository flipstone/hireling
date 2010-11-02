#!/usr/bin/env ruby
#
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

NewHire.each_app_hire_name do |hire_name|
  new_hire_class = hire_name.to_s.classify.constantize
  new_hire_class.schedule_with_scheduler scheduler
end

scheduler.join
