require 'sinatra'

require_relative 'lib/api/params'
require_relative 'lib/api/response'

require_relative 'lib/cli/git_commits'

require_relative 'lib/utils/gcoms_options'
require_relative 'lib/github_api'

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