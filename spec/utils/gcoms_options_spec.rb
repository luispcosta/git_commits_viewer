require 'spec_helper'

describe Utils::GcomsOptions do
  subject(:dummy) { Class.new.extend(described_class) }

  describe '#check_required_arguments' do
    it 'should raise an error if github URL is not present' do
      expect { dummy.check_required_arguments({}) }.to raise_error(Utils::GcomsOptions::InvalidOption)
      expect { dummy.check_required_arguments({url: nil}) }.to raise_error(Utils::GcomsOptions::InvalidOption)
      expect { dummy.check_required_arguments({url: ''}) }.to raise_error(Utils::GcomsOptions::InvalidOption)
    end

    it 'should not raise an error if github url is present' do
      expect { dummy.check_required_arguments({url: 'some_url'}) }.not_to raise_error
    end
  end

  describe '#validate_github_url' do
    it { expect { dummy.validate_github_url(nil) }.to raise_error(Utils::GcomsOptions::InvalidOption) }
    it { expect { dummy.validate_github_url('') }.to raise_error(Utils::GcomsOptions::InvalidOption) }

    it { expect { dummy.validate_github_url('https://something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('http://something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('https://github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('http://github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('git://github.com/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('git://github.com/something/something.something') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }
    it { expect { dummy.validate_github_url('git@github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /not a valid github url/) }

    context 'a valid github url but does not point to an existent repo' do
      before do
        allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(false)
      end

      it { expect { dummy.validate_github_url('git://github.com/something/something.git') }.to raise_error(Utils::GcomsOptions::InvalidOption, /does not point to a valid github repository/i) }
    end

    context 'a valid github url and point to an existent repo' do
      before do
        allow_any_instance_of(Utils::GitCLI).to receive(:repo_exists?).and_return(true)
      end

      it { expect { dummy.validate_github_url('git://github.com/something/something.git') }.not_to raise_error }
      it { expect { dummy.validate_github_url("  GiT://GithuB.coM/something/something.gIT  \n\n\n\n") }.not_to raise_error }
    end
  end
end