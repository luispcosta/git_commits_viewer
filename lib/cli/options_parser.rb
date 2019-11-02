# frozen_string_literal:true

require 'optparse'
require_relative '../utils/gcoms_options'

module CLI
  # Options parser for the CLI interface.
  class OptionsParser
    extend Utils::GcomsOptions
    class << self
      def parse!(args)
        options = Utils::GcomsOptions::DEFAULT_OPTS.dup

        OptionParser.new do |opts|
          opts.banner = 'Usage: ruby gcoms.rb [options]'
          opts.separator 'Example: ruby gcoms.rb --url=git://github.com/rails/rails.git -p=2 -l=10 --branch=somebranch'
          opts.separator ''

          page_opt_setup(options, opts)
          per_page_opt_setup(options, opts)

          opts.on('-uURL', '--url=URL', String, url_explanation) do |url|
            options[:url] = validate_github_url(url)
          end

          opts.on('-bBRANCH', '--branch=BRANCH', String, branch_explanation) do |b|
            options[:branch] = b
          end

          opts.separator('')

          opts.on('-h', '--help', 'Prints this help message') do
            puts opts
            exit
          end
        end.parse!(args)

        check_required_arguments(options)
      end

      def page_opt_setup(program_opts, parser)
        parser.on('-pPAGE', '--page=PAGE', Integer, page_explanation) do |p|
          raise Utils::GcomsOptions::InvalidOption, 'Page must be greater than or equal to 1' if p&.negative?

          program_opts[:page] = p
        end
      end

      def per_page_opt_setup(program_opts, parser)
        parser.on('-lPER_PAGE', '--per-page=PER_PAGE', Integer, per_page_explanation) do |per_page|
          raise Utils::GcomsOptions::InvalidOption, 'Per page must be greater than or equal to 1' if per_page&.negative?

          if per_page && per_page > Utils::GcomsOptions::MAX_PER_PAGE
            err = "Per page must lower than or equal to #{Utils::GcomsOptions::MAX_PER_PAGE}"
            raise Utils::GcomsOptions::InvalidOption, err
          end

          program_opts[:per_page] = per_page
        end
      end

      def page_explanation
        <<-HEREDOC
          Prints the commit list starting from this specific page.
          Defaults to #{DEFAULT_PAGE}. Must be a number greater than or equal to 1
        HEREDOC
      end

      def per_page_explanation
        <<-HEREDOC
          Number of commits to print per page.
          Defaults to #{DEFAULT_PER_PAGE}.
          Must be a number greater than or equal to 1 and lower than or equal to #{Utils::GcomsOptions::MAX_PER_PAGE}"
        HEREDOC
      end

      def url_explanation
        <<-HEREDOC
          The Github project url. The expected format is git://github.com/_owner_/_repo_.git.
          We only accept urls with the git protocol so that you dont have to provide a username and password when interacting with git
        HEREDOC
      end

      def branch_explanation
        <<-HEREDOC
          The branch to see the commits. Defaults to #{DEFAULT_BRANCH}.
          If the branch name you provide does not exist, this script return no commits.
        HEREDOC
      end
    end
  end
end
