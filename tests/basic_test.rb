require 'fileutils'
require_relative 'test_utils'

puts `ruby ../Source/codgen.rb config.json`

error = TestUtils.recursive_compare('expected_output', 'Output')

unless error
  puts 'Success!'
end