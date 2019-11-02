# frozen_string_literal:true

require_relative '../utils/gcoms_options'

module API
  # Class to handle the params passed via the API endpoints.
  class Params
    extend Utils::GcomsOptions

    def self.parse(params)
      options = Utils::GcomsOptions::DEFAULT_OPTS.clone

      if params[:page]
        page = Integer(params[:page]) rescue nil
        raise Utils::GcomsOptions::InvalidOption, 'Page must be greater than or equal to 1' if page&.negative?

        options[:page] = page if page
      end

      if params[:per_page]
        per_page = Integer(params[:per_page]) rescue nil
        raise Utils::GcomsOptions::InvalidOption, 'Per page must be greater than or equal to 1' if per_page&.negative?

        max_per_page = Utils::GcomsOptions::MAX_PER_PAGE
        if per_page && per_page > max_per_page
          raise Utils::GcomsOptions::InvalidOption, "Per page must lower than or equal to #{max_per_page}"
        end

        options[:per_page] = per_page if per_page
      end

      options[:branch] = params[:branch].strip.chomp if params[:branch]
      options[:url] = params[:url].strip.chomp if params[:url]

      check_required_arguments(options)

      validate_github_url(options[:url])

      options
    end
  end
end
