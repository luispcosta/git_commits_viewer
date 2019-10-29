require_relative 'git_cli'
require 'pry-byebug'

class Gcoms
  def initialize(options)
    @options = options
  end
  
  def list_commits
    GitCLI.clone(@options[:url], @options[:branch]) do |repo_path|
      GitCLI.log(repo_path, @options[:page], @options[:per_page])
    end
  end
end