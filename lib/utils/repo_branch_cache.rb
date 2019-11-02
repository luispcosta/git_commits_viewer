require 'fileutils'

module Utils
  class RepoBranchCache
    CACHE_TTL = 600 # 15 minutes, or 900 seconds
    TMP_FOLDER = 'tmp'.freeze

    def initialize(repo_name, branch)
      @repo_name = repo_name
      @branch = branch
    end

    def expired?
      cache_folder_exists? ? (Time.now - CACHE_TTL) >= File.mtime(cache_folder) : true
    end

    def delete
      return unless cache_folder_exists?

      FileUtils.rm_rf Dir.glob("#{cache_folder}/*")
      FileUtils.rm_rf cache_folder
    end

    def cached
      Dir.mkdir(TMP_FOLDER) unless Dir.exist?(TMP_FOLDER)
      Dir.mkdir("#{TMP_FOLDER}/#{repo_name}") unless Dir.exist?("#{TMP_FOLDER}/#{repo_name}")
      Dir.mkdir(cache_folder) unless cache_folder_exists?
      yield
      FileUtils.touch(cache_folder)
    end

    def cache_folder
      @cache_folder ||= "#{TMP_FOLDER}/#{repo_name}/#{branch}"
    end

    private

    attr_reader :repo_name, :branch

    def cache_folder_exists?
      Dir.exist?(TMP_FOLDER) && Dir.exist?("#{TMP_FOLDER}/#{repo_name}") && Dir.exist?("#{TMP_FOLDER}/#{repo_name}/#{branch}")
    end
  end
end