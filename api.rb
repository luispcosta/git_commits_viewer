# frozen_string_literal:true

require 'sinatra'

require_relative 'lib/api/params'
require_relative 'lib/api/response'

require_relative 'lib/cli/git_commits'

require_relative 'lib/utils/gcoms_options'
require_relative 'lib/github_api'

def valid_port_number?(arg)
  Integer(arg)
rescue StandardError
  false
end

if ARGV.any?
  if ARGV.size == 1 && valid_port_number?(ARGV.first)
    set :port, ARGV.first.to_i
  else
    puts "Unrecognized arguments #{ARGV}. If you wish to run this API on a different port, please run ruby.rb api PORT"
    exit - 1
  end
end

get '/commits' do
  content_type :json

  options = API::Params.parse(params)
  client = GithubAPI.new(options)
  API::Response.ok(client.list_commits)
rescue Utils::GcomsOptions::InvalidOption => e
  status 400
  API::Response.error(e.message)
rescue GithubAPI::Error
  API::Response.ok(CLI::GitCommits.new(options).list)
rescue StandardError => e
  status 400
  API::Response.error(e.message)
end

not_found do
  'Page not found'
end
