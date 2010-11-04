#!/usr/bin/env ruby
#
# This file is invoked by the Daemons.run and launches the hirelings.
# Hireling control relies on the Rails environment for:
#  - config/initializers/hirelings_schedule.rb
#  - app/hirelings/<your_hirelings>.rb
#
ENV["RAILS_ENV"] ||= "development"

require "daemons"
require 'rufus/scheduler'
require "#{Daemons.controller.options[:rails_root]}/config/environment"

scheduler = Rufus::Scheduler.start_new

Hireling.each_app_hireling_name(Daemons.controller.options[:rails_root]) do |hireling_name|
  hireling_class = hireling_name.to_s.camelize.constantize
  hireling_class.schedule_with_scheduler scheduler
end

scheduler.join
