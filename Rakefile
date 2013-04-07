#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Specifind'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


desc "Run all metrics"
task :metrics do
  puts "Generating Metrics with metric_fu.\nCheck your browser for output."
  `metric_fu -r`
end


Bundler::GemHelper.install_tasks

desc "Run all specs"
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
