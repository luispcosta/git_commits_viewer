require 'sinatra'
require_relative 'lib/api_params'
require_relative 'lib/gcoms_options'
require_relative 'lib/gcoms'
require_relative 'lib/api_response'
require 'pry-byebug'


get '/commits' do
  content_type :json

  options = ApiParams.parse(params)
  ApiResponse.ok(Gcoms.new(options).list_commits)
rescue GcomsOptions::InvalidOption => e
  status 400
  ApiResponse.error(e.message)
end

not_found do
  'Page not found'
end