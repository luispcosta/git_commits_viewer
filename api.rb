require 'sinatra'
require_relative 'lib/api_params'
require_relative 'lib/gcoms_options'
require_relative 'lib/gcoms'
require_relative 'lib/api_response'
require_relative 'lib/github_api'

get '/commits' do
  content_type :json

  options = ApiParams.parse(params)
  client = GithubAPI.new(options)
  ApiResponse.ok(client.list_commits)
rescue GcomsOptions::InvalidOption => e
  status 400
  ApiResponse.error(e.message)
rescue GithubAPI::Error
  ApiResponse.ok(Gcoms.new(options).list_commits)
rescue StandardError => e
  status 400
  ApiResponse.error(e.message)
end

not_found do
  'Page not found'
end