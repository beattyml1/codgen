require "bundler/gem_tasks"
#require_relative 'test/behavior/output_spec'
#Dir['test/unit/*.rb'].each {|file| require_relative file }
require 'rspec/core/rake_task'

Dir.chdir('test/data')

task :unit_tests do
  puts ''
  puts 'Running unit tests'
  puts `rspec ../unit/*_spec.rb`
  puts ''
  puts ''
end

task :behavior_tests do
  puts 'Running behavior tests'
  puts `rspec ../behavior/output_spec.rb`
end

task :default => [:unit_tests, :behavior_tests] do

end