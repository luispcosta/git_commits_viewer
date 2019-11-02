# frozen_string_literal:true

require_relative 'lib/cli/options_parser'
require_relative 'lib/cli/git_commits'

begin
  options = CLI::OptionsParser.parse!(ARGV)
  puts CLI::GitCommits.new(options).list
rescue StandardError => e
  puts "Unexpected error: #{e}"
  exit 1
end
