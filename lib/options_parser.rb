require 'optparse'

class OptionsParser
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 100
  DEFAULT_BRANCH = 'master'.freeze

  InvalidOption = Class.new(StandardError)

  GITHUB_URL_REGEXP = /((git@|http(s)?:\/\/)([\w\.@]+)(\/|:))([\w,\-,\_]+)\/([\w,\-,\_]+)(.git){0,1}((\/){0,1})/.freeze

  class << self
    def parse!(args)
      options = {
        page: DEFAULT_PAGE,
        per_page: DEFAULT_PER_PAGE,
        url: nil,
        branch: DEFAULT_BRANCH
      }

      OptionParser.new do |opts|
        opts.banner = 'Usage: ruby gcoms.rb [options]'
        opts.separator 'Example: ruby gcoms.rb --url=https://github.com/rails -p=2 -l=10 --branch=somebranch'
        opts.separator ''
        
        opts.on("-pPAGE", "--page=PAGE", Integer, "Prints the commit list starting from this specific page. Defaults to #{DEFAULT_PAGE}") do |p|
          options[:page] = p
        end
      
        opts.on('-lPER_PAGE', '--per-page=PER_PAGE', Integer, "Number of commits to print per page. Defaults to #{DEFAULT_PER_PAGE}") do |per_page|
          options[:per_page] = per_page
        end

        opts.on('-uURL', '--url=URL', String, "The Github project url") do |url|
          options[:url] = validate_github_url(url)
        end

        opts.on('-bBRANCH', '--branch=BRANCH', String, "The branch to see the commits. Defaults to #{DEFAULT_BRANCH}") do |b|
          options[:branch] = b
        end

        opts.separator("")

        opts.on('-h', '--help', 'Prints this help message') do
          puts opts
          exit
        end

      end.parse!(args)

      check_required_arguments!(options)
      options
    end

    private

    def validate_github_url(url)
      raise InvalidOption, "Url #{url} is not a valid github url. See the help section with the --help option." if url&.empty?
      url = url.strip.chomp

      return url if url.match?(GITHUB_URL_REGEXP)

      raise InvalidOption, "Url #{url} is not a valid github url. See the help section with the --help option."
    end

    def check_required_arguments!(options)
      raise OptionParser::MissingArgument, "Github URL was not provided" if options[:url].nil? || options[:url].empty?
    end
  end
end

