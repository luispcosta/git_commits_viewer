require_relative 'repo_branch_cache'

class GitCLI
  def initialize(url, branch)
    @url = url
    @branch = branch
  end

  def clone
    with_local_cache_repo_repo do |path|
      yield path if block_given?
    end
  end

  def log(page, per_page)
    skip = ((page <= 0 ? 2 : page) - 1) * per_page
    res = `cd #{repo_cache.cache_folder} && git log --skip=#{skip} --max-count=#{per_page} --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "message": "%f"%n},' $@ | perl -pe 'BEGIN{print "["}; END{print "]\n"}' | perl -pe 's/},]/}]/'`
    JSON.load(res)
  end

  private

  attr_reader :url, :branch

  def repo_name(url)
    url.split("/")[-1].split(".git")[0]
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
    @repo_cache ||= RepoBranchCache.new(repo_name(url), branch)
  end
end