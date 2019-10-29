require_relative 'git_cli'

class Gcoms
  def initialize(options)
    @options = options
  end
  
  def list_commits
    client = GitCLI.new(@options[:url], @options[:branch])
    client.clone
    client.log(@options[:page], @options[:per_page])
  end
end