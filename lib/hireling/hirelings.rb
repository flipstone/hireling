#!/usr/bin/env ruby
#
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../../config/environment"
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

NewHire.each_app_hireling_name do |hireling_name|
  hireling_class = hireling_name.to_s.classify.constantize
  hireling_class.schedule_with_scheduler scheduler
end

scheduler.join
