# frozen_string_literal:true

require_relative 'lib/cli/options_parser'
require_relative 'lib/utils/git_cli'

begin
  options = CLI::OptionsParser.parse!(ARGV)
  cli = Utils::GitCLI.new(options)
  cli.clone
  puts cli.log
rescue Utils::GcomsOptions::InvalidOption => e
  puts "Invalid options: #{e}"
  exit 1
end
