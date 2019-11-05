require 'spec_helper'

describe Utils::GitCLI do
  describe '#log' do
    before do
      Dir.mkdir('repo_test') unless Dir.exist?('repo_test')
      `cd repo_test && git init`
    end

    after do
      FileUtils.rm_rf Dir.glob("repo_test/*")
      FileUtils.rm_rf 'repo_test'
    end

    context 'with no commits' do
      it 'should not print anything' do
        cache_stub = double('cache_stub')
        allow(cache_stub).to receive(:cache_folder).and_return('repo_test')
        commits = Utils::GitCLI.new(url: 'git://github.com/some/repo.git', repo_cache: cache_stub).log
        expect(commits).to eq([])
      end
    end

    context 'with commits' do
      before do
        `touch repo_test/README1.md && cd repo_test && git add . && git commit -m 'initial commit 1'`
        `touch repo_test/README2.md && cd repo_test && git add . && git commit -m 'commit 2'`
      end 

      it 'should get all the commits' do
        cache_stub = double('cache_stub')
        allow(cache_stub).to receive(:cache_folder).and_return('repo_test')
        commits = Utils::GitCLI.new(url: 'git://github.com/some/repo.git', repo_cache: cache_stub).log
        expect(commits.count).to eq 2
        expect(commits[0]['message']).to match(/commit-2/)
        expect(commits[1]['message']).to match(/initial-commit-1/)
      end

      it 'should only get first commit when paginating with 1 commit per page' do
        cache_stub = double('cache_stub')
        allow(cache_stub).to receive(:cache_folder).and_return('repo_test')
        commits = Utils::GitCLI.new(url: 'git://github.com/some/repo.git', per_page: 1, page: 1, repo_cache: cache_stub).log
        expect(commits.count).to eq 1
        expect(commits[0]['message']).to match(/commit-2/)
      end

      it 'should only two commits paginating with 2 commit per page' do
        cache_stub = double('cache_stub')
        allow(cache_stub).to receive(:cache_folder).and_return('repo_test')
        commits = Utils::GitCLI.new(url: 'git://github.com/some/repo.git', per_page: 2, page: 1, repo_cache: cache_stub).log
        expect(commits.count).to eq 2
        expect(commits[0]['message']).to match(/commit-2/)
        expect(commits[1]['message']).to match(/initial-commit-1/)
      end

      it 'should not return anything when requesting one commit per page and requesting page 3' do
        cache_stub = double('cache_stub')
        allow(cache_stub).to receive(:cache_folder).and_return('repo_test')
        commits = Utils::GitCLI.new(url: 'git://github.com/some/repo.git', per_page: 1, page: 3, repo_cache: cache_stub).log
        expect(commits.count).to eq 0
      end
    end
  end
end