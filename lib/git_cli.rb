require 'fileutils'

class GitCLI
  CACHE_TTL = 600 # 15 minutes, or 900 seconds

  class << self
    def clone(url, branch)
      with_local_cache_repo_repo(url, repo_name(url), branch) do |path|
        yield path
      end
    end

    def log(repo_path, page, per_page)
      skip = ((page <= 0 ? 2 : page) - 1) * per_page
      res = `cd #{repo_path} && git log --skip=#{skip} --max-count=#{per_page} --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "message": "%f"%n},'`
      JSON.load(res)
    end

    private

    def with_local_cache_repo_repo(url, repository_name, branch)
      if expired_cache?(repository_name, branch)
        delete_cache_folder(repository_name, branch)
        clone_repo_to_local_folder(url, repository_name, branch) 
      end

      yield cache_folder(repository_name, branch)
    end

    def clone_repo_to_local_folder(url, name, branch)
      base = 'tmp'
      folder = cache_folder(name, branch)
      Dir.mkdir(base) unless Dir.exist?(base)
      Dir.mkdir("#{base}/#{name}") unless Dir.exist?("#{base}/#{name}")
      Dir.mkdir(folder) unless  cache_folder_exists?(name, branch)

      `git clone #{url} --branch #{branch} --single-branch #{folder}`
      FileUtils.touch(folder)
    end

    def delete_cache_folder(name, branch)
      return unless Dir.exist?(cache_folder(name, branch))

      FileUtils.rm_rf Dir.glob("#{cache_folder(name, branch)}/*")
      FileUtils.rm_rf "tmp/#{name}/#{branch}"
    end

    def expired_cache?(name, branch)
      cache_folder_exists?(name, branch) ? (Time.now - CACHE_TTL) >= File.mtime(cache_folder(name, branch)) : true
    end

    def cache_folder(name, branch)
      "tmp/#{name}/#{branch}"
    end

    def cache_folder_exists?(name, branch)
      Dir.exist?('tmp') && Dir.exist?("tmp/#{name}") && Dir.exist?("tmp/#{name}/#{branch}")
    end

    def repo_name(url)
      url.split("/")[-1].split(".git")[0]
    end
  end
end