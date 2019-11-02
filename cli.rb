require_relative 'lib/options_parser'
require_relative 'lib/gcoms'

options = {}
begin
  options = OptionsParser.parse!(ARGV)
rescue StandardError => e
  puts "Unexpected error: #{e}"
  exit 1
end

puts Gcoms.new(options).list_commits


