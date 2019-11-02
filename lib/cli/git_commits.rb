# frozen_string_literal:true

require_relative '../utils/git_cli'

module CLI
  # Class to fetch the list of commits of a local cloned git repository
  class GitCommits
    def initialize(options)
      @options = options
    end

    def list
      client = Utils::GitCLI.new(@options[:url], @options[:branch])
      client.clone
      client.log(@options[:page], @options[:per_page])
    end
  end
end
