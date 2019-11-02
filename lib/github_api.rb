require 'http'
require_relative 'gcoms_options'

class GithubAPI
  TIMEOUT_WAIT_SECONDS = 15

  class Error < StandardError; end

  def initialize(opts)
    @opts = opts
  end

  def list_commits
    response = HTTP.timeout(TIMEOUT_WAIT_SECONDS)
                   .headers(accept: 'application/json')
                   .get(api_url)
    if response.status.success?
      parse_result(response.body.to_s)
    else
      raise Error, response.body.to_s
    end
  rescue HTTP::Error
    raise Error
  end

  private

  def parse_result(result)
    json = JSON.load(result)
    json.map do |commit|
      parse_commit(commit)
    end
  end

  def parse_commit(commit)
    hash = {}
    hash[:commit] = commit['sha']
    
    hash[:author] = "#{commit['commit']['author']['name']} <#{commit['commit']['author']['email']}>"
    hash[:date] = commit['commit']['author']['date']
    hash[:message] = commit['commit']['message']
    hash
  end

  def page
    @page ||= @opts[:page]
  end

  def per_page
    @per_page ||= @opts[:per_page]
  end

  def branch
    @branch ||= @opts[:branch]
  end

  def repo_owner
    url_parts[0]
  end

  def repo
    url_parts[1].split(".git")[0]
  end 

  def url_parts
    @url_parts ||= @opts[:url].split("github.com/")[1].split("/")
  end

  def api_url
    @api_url ||= "https://api.github.com/repos/#{repo_owner}/#{repo}/commits?page=#{page}&per_page=#{per_page}&sha=#{branch}"
  end
end