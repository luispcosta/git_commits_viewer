# frozen_string_literal: true

module Utils
  # Module with helpers to configure both the CLI and API entry points.
  module GcomsOptions
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 100
    DEFAULT_BRANCH = 'master'
    MAX_PER_PAGE = 1000

    InvalidOption = Class.new(StandardError)

    GITHUB_URL_REGEXP = %r{((git:\/\/)([\w\.@]+)(\/|:))([\w,\-,\_]+)\/([\w,\-,\_]+)(.git){1}((\/){0,1})}.freeze

    DEFAULT_OPTS = {
      page: DEFAULT_PAGE,
      per_page: DEFAULT_PER_PAGE,
      url: nil,
      branch: DEFAULT_BRANCH
    }.freeze

    def validate_github_url(url)
      raise InvalidOption, "Url #{url} is not a valid github url." if url.nil? || url&.empty?

      url = url.strip.chomp.downcase

      err = "Url #{url} is not a valid github url Expected format: git://github.com/rails/rails.git"
      raise InvalidOption, err unless url.match?(GITHUB_URL_REGEXP)

      err = "Url #{url} does not point to a valid github repository"
      raise InvalidOption, err unless Utils::GitCLI.new(url: url).repo_exists?

      url
    end

    def check_required_arguments(options)
      raise InvalidOption, 'Github URL was not provided' if options.dig(:url).nil? || options.dig(:url).empty?

      options
    end
  end
end
