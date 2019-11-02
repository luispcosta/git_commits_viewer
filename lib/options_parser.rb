require 'optparse'
require_relative 'gcoms_options'

class OptionsParser
  extend GcomsOptions
  class << self
    def parse!(args)
      options = GcomsOptions::DEFAULT_OPTS.clone

      OptionParser.new do |opts|
        opts.banner = 'Usage: ruby gcoms.rb [options]'
        opts.separator 'Example: ruby gcoms.rb --url=git://github.com/rails/rails.git -p=2 -l=10 --branch=somebranch'
        opts.separator ''
        
        opts.on("-pPAGE", "--page=PAGE", Integer, "Prints the commit list starting from this specific page. Defaults to #{DEFAULT_PAGE}") do |p|
          raise GcomsOptions::InvalidOption, "Page must be greater than or equal to 1" if p && p < 0

          options[:page] = p
        end
      
        opts.on('-lPER_PAGE', '--per-page=PER_PAGE', Integer, "Number of commits to print per page. Defaults to #{DEFAULT_PER_PAGE}") do |per_page|
          raise GcomsOptions::InvalidOption, "Per page must be greater than or equal to 1" if per_page && per_page < 0
         raise GcomsOptions::InvalidOption, "Per page must lower than or equal to #{GcomsOptions::MAX_PER_PAGE}" if per_page && per_page > GcomsOptions::MAX_PER_PAGE

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

      check_required_arguments(options)
    end
  end
end

