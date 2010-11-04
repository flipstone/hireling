require 'rake/gempackagetask'

require 'rubygems'

specification = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name   = "hireling"
  s.summary = "Simple scheduled process structure for Rails apps."
  s.version = "0.2.1"
  s.author = "David Vollbracht, Scott Conley"
  s.description = s.summary
  s.email = "scott.conley@flipstone.com"
  s.homepage = ""
  s.rubyforge_project = ""
  s.executables = ["hirelings_ctl"]
  s.has_rdoc = false
  s.add_dependency('daemons', '>= 1.0.10')
  s.add_dependency('rufus-scheduler', '>= 2.0.6')
  
  s.files = FileList['{lib,test,bin}/**/*', 'Rakefile'].to_a
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end
