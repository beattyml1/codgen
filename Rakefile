require "bundler/gem_tasks"
#require_relative 'test/behavior/output_spec'
#Dir['test/unit/*.rb'].each {|file| require_relative file }
require 'rspec/core/rake_task'

task :unit_tests do
  Dir.chdir('test/data/Input')
  puts ''
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = '../../unit/*_spec.rb'
  end
  puts 'Running unit tests'
  Rake::Task["spec"].execute
  puts ''
  puts ''
  Dir.chdir('../../..')
end

task :behavior_tests do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'test/behavior/output_spec.rb'
  end
  puts 'Running behavior tests'
  Rake::Task["spec"].execute
end

task :default => [:unit_tests, :behavior_tests] do

end