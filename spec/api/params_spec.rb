require 'spec_helper'

describe API::Params do
  describe '.parse' do
    let(:valid_github_url) { 'git://github.com/something/something.git' }

    it 'should raise an error when page is negative' do
      expect { described_class.parse(page: -1) }.to raise_error(Utils::GcomsOptions::InvalidOption, /must be greater than or equal to 1/)
    end

    it 'should raise an error when page is 0' do
      expect { described_class.parse(page: 0, url: valid_github_url) }.to raise_error(Utils::GcomsOptions::InvalidOption, /must be greater than or equal to 1/)
    end

    it 'should not raise an error when page is not integer' do
      allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(true)
      expect { described_class.parse(page: "123123", url: valid_github_url) }.not_to raise_error
    end

    it 'should raise an error page is integer and per page is negative' do
      expect { described_class.parse(page: 1, per_page: -1) }.to raise_error(Utils::GcomsOptions::InvalidOption, /must be greater than or equal to 1/)
    end

    it 'should raise an error page is integer and per page is 0' do
      expect { described_class.parse(page: 1, per_page: 0) }.to raise_error(Utils::GcomsOptions::InvalidOption, /must be greater than or equal to 1/)
    end

    it 'should not raise an error page is integer and per page is string' do
      allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(true)
      expect { described_class.parse(page: 1, per_page: "something", url: valid_github_url) }.not_to raise_error
    end

    it 'should raise an error page is integer and per page greater then max allowed' do
      expect { described_class.parse(page: 1, per_page: 88888) }.to raise_error(Utils::GcomsOptions::InvalidOption, /must be lower than or equal to/)
    end

    it 'should raise an error page is integer and per page is integer but url is not present' do
      expect { described_class.parse(page: 1, per_page: 50, url: nil) }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
    end

    it 'should raise an error page is integer and per page is integer but url is invalid' do
      expect { described_class.parse(page: 1, per_page: 50, url: '') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'https://something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'http://something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'https://github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'http://github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'git://github.com/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'git://github.com/something/something.something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
      expect { described_class.parse(page: 1, per_page: 50, url: 'git@github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/)
    end

    it 'should raise an error page is integer and per page is integer and url is valid but points to non existent repo' do
      allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(false)
      expect { described_class.parse(page: 1, per_page: 50, url: valid_github_url) }.to raise_error(Utils::GcomsOptions::InvalidOption, /does not point to a valid github repository/)
    end

    it 'should not raise an error page is integer and per page is integer and url is valid and points to existent repo' do
      allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(true)
      expect { described_class.parse(page: 1, per_page: 50, url: valid_github_url) }.not_to raise_error
    end
  end
end