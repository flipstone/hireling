require 'rake/gempackagetask'

require 'rubygems'

specification = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name   = "new_hire"
  s.summary = "Simple scheduled process structure for Rails apps."
  s.version = "0.1"
  s.author = "David Vollbracht, Scott Conley"
  s.description = s.summary
  s.email = "scott.conley@flipstone.com"
  s.homepage = ""
  s.rubyforge_project = ""
  s.bindir = "bin"
  s.has_rdoc = false

  s.files = FileList['{lib,test}/**/*.{rb,rake}', 'Rakefile'].to_a
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end

# Rake::Task[:gem].prerequisites.unshift :default