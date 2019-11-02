require_relative '../utils/git_cli'

module CLI
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