class NewHire
  attr_accessor :reraise_work_item_errors

  class <<self
    attr_accessor :schedule
  end

_name
    Dir[File.join(Rails.root, %w(app new_hires *.rb))].each do |hire_file|
      hire_name = File.basename(hire_file, '.rb')
      yield hire_name.to_sym
    end
  end

  def self.schedule_with_scheduler(scheduler)
    NewHire.schedule.schedule(scheduler, new)
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
    Rails.logger.info "WorkingGirl #{name} at #{Time.now}: #{message}"
  end

  class Schedule
    def initialize
      @proxies = {}
    end
    def [](new_hire_name)
      @proxies[new_hire_name] = SchedulerProxy.new
    end

    def schedule(rufus_scheduler, new_hire)
      proxy = @proxies[new_hire.class.name.underscore.to_sym]
      raise "No schedule found for #{new_hire.class}" unless proxy
      proxy.replay(rufus_scheduler,new_hire)
    end
  end

  class SchedulerProxy
    def replay(rufus_scheduler, new_hire)
      rufus_scheduler.send(@method, @arg, new_hire, :blocking => true)
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

