require "bundler/gem_tasks"
#require_relative 'test/behavior/output_spec'
#Dir['test/unit/*.rb'].each {|file| require_relative file }
require 'rspec/core/rake_task'


task :unit_tests do
  Dir.chdir('test/data/Input')
  puts ''
  puts 'Running unit tests'
  puts `rspec ../../unit/*_spec.rb`
  puts ''
  puts ''
  Dir.chdir('../../..')
end

task :behavior_tests do
  puts 'Running behavior tests'
  puts `rspec test/behavior/output_spec.rb`
end

task :default => [:unit_tests, :behavior_tests] do

end