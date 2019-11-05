# frozen_string_literal:true

require_relative 'repo_branch_cache'
require 'open3'
require 'json'
require 'date'

module Utils
  # Class to interact with the system's git command.
  class GitCLI
    def initialize(options)
      @url = options[:url]
      @branch = options[:branch] || GcomsOptions::DEFAULT_BRANCH
      @page = options[:page] || GcomsOptions::DEFAULT_PAGE
      @per_page = options[:per_page] || GcomsOptions::DEFAULT_PER_PAGE
      @repo_cache = options[:repo_cache]
    end

    def clone
      with_local_cache_repo_repo do |path|
        yield path if block_given?
      end
    end

    def log
      skip = ((page <= 0 ? 2 : page) - 1) * per_page
      # rubocop:disable Metrics/LineLength
      #
      # Rundown of command:
      # The format passed to --pretty simply tells git to format each commit in the log with a line starting with '{' and
      #   ending with a '},'. Inside this pseudo 'hash' string we include the commit author, sha1, date and message.
      # Then, we pipe this output into perl which will loop through each line created with the pretty command and append
      #   a [ at the beginning (the opening of the JSON array of commits) and append a ]\n at the end (the ending of the JSON
      #   array of commits).
      # Finally, because the pretty option will append a ',' at the end of each line (we don't know how many commits we're priting
      #   so we just append a comma at the end of each line, even if it is the last), we are effectivelly ending the output as
      #   ... ],}, which creates an invalid json. So, we pipe the output of the previous step into a perl program that 
      #   replaces the string ],} with ]} creating a valid JSON array of objects.
      #
      res = `cd #{repo_cache.cache_folder} && git log --skip=#{skip} --max-count=#{per_page} --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "message": "%f"%n},' | perl -pe 'BEGIN{print "["}; END{print "]\n"}' | perl -pe 's/},]/}]/'`
      # rubocop:enable Metrics/LineLength

      ::JSON.parse(res)
    end

    def repo_exists?
      _, err, = Open3.capture3("git ls-remote #{url}")
      err.empty?
    end

    private

    attr_reader :url, :branch, :page, :per_page

    def repo_name(url)
      url.split('/')[-1].split('.git')[0]
    end

    def with_local_cache_repo_repo
      if repo_cache.expired?
        repo_cache.delete
        repo_cache.cached do
          `git clone #{url} --branch #{branch} --single-branch #{repo_cache.cache_folder}`
        end
      end

      yield repo_cache.cache_folder
    end

    def repo_cache
      @repo_cache ||= Utils::RepoBranchCache.new(repo_name(url), branch)
    end
  end
end
