require 'pry-byebug'

module GcomsOptions
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 100
  DEFAULT_BRANCH = 'master'.freeze

  InvalidOption = Class.new(StandardError)

  GITHUB_URL_REGEXP = /((git:\/\/)([\w\.@]+)(\/|:))([\w,\-,\_]+)\/([\w,\-,\_]+)(.git){0,1}((\/){0,1})/.freeze

  DEFAULT_OPTS = {
    page: DEFAULT_PAGE,
    per_page: DEFAULT_PER_PAGE,
    url: nil,
    branch: DEFAULT_BRANCH,
  }

  def validate_github_url(url)
    raise InvalidOption, "Url #{url} is not a valid github url." if url&.empty?
    url = url.strip.chomp
    
    if url.match?(GITHUB_URL_REGEXP)
      raise InvalidOption, "Url #{url} does not point to a valid github repository" unless GitCLI.repo_exists?(url)
      url
    else
      raise InvalidOption, "Url #{url} is not a valid github url Expected format: git://github.com/rails/rails.git"
    end
  end

  def check_required_arguments(options)
    raise InvalidOption, "Github URL was not provided" if options.dig(:url).nil? || options.dig(:url).empty?

    options
  end
end