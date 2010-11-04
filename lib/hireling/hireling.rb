class Hireling
  attr_accessor :reraise_work_item_errors

  class <<self
    attr_accessor :schedule
  end

  def self.each_app_hireling_name(rails_root)
    hireling_classes ||= Dir[File.join(rails_root, %w(app hirelings *.rb))]
    hireling_classes ||= Dir[File.join(%w(app hirelings *.rb))]
    hireling_classes.each do |hireling_file|
      require hireling_file
      hireling_name = File.basename(hireling_file, '.rb')
      yield hireling_name.to_sym
    end
  end

  def self.schedule_with_scheduler(scheduler)
    Hireling.schedule.schedule(scheduler, new)
    info "scheduled"
  end

  def call(job)
    self.class.info "starting work"
    work
    self.class.info "done working"
  end

  def work
    raise "#{self.class.name} doesn't know how to do their job."
  end

  def work_on_items_from(scope)
    scope.find_each(:batch_size => 100) do |item|
      begin
        yield item
      rescue Exception => e
        Rails.logger.error "#{e.class}: #{e.message} - #{e.backtrace.join("\n  ")}"
        raise e if reraise_work_item_errors
      end
    end
  end

  def self.info(message)
    Rails.logger.info "Hireling #{name} at #{Time.now}: #{message}"
  end

  class Schedule
    def initialize
      @proxies = {}
    end
    def [](hireling_name)
      @proxies[hireling_name] = SchedulerProxy.new
    end

    def schedule(rufus_scheduler, hireling)
      proxy = @proxies[hireling.class.name.underscore.to_sym]
      raise "No schedule found for #{hireling.class.name.underscore.to_sym}" unless proxy
      proxy.replay(rufus_scheduler,hireling)
    end
  end

  class SchedulerProxy
    def replay(rufus_scheduler, hireling)
      rufus_scheduler.send(@method, @arg, hireling, :blocking => true)
    end

    [:at, :every, :cron].each do |scheduler_method|
      eval %{
        def #{scheduler_method}(arg)
          @method = #{scheduler_method.inspect}
          @arg = arg
        end
      }
    end
  end
end

