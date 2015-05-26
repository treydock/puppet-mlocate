require 'spec_helper'

describe 'mlocate' do

  context 'with defaults for all parameters' do
    it { should contain_class('mlocate') }
    it { should contain_class('mlocate::install') }
    it { should contain_class('mlocate::cron') }
    it { should contain_file('updatedb.conf').with_path('/etc/updatedb.conf') }
    it { should contain_file('updatedb.conf').with_content(/^PRUNE_BIND_MOUNTS = "yes"$/) }
    it { should contain_file('updatedb.conf').with_content(/^PRUNENAMES = ".git .hg .svn"$/) }
    it { should contain_file('updatedb.conf').with_content(/^PRUNEPATHS = \"\/afs .*$/) }
    it { should contain_file('updatedb.conf').with_content(/^PRUNEFS = \"9p afs .*$/) }

    context 'with facts osfamily, operatingsystemmajrelease set to redhat , 5' do
        let(:facts) { {:osfamily => 'RedHat', :operatingsystemmajrelease => 5} }
        it { should contain_file('updatedb.conf').with_path('/etc/updatedb.conf') }
        it { should_not contain_file('updatedb.conf').with_content(/^PRUNE_BIND_MOUNTS.*$/) }
        it { should_not contain_file('updatedb.conf').with_content(/^PRUNENAMES.*$/) }
        it { should contain_file('updatedb.conf').with_content(/^PRUNEPATHS = \"\/afs .*$/) }
        it { should contain_file('updatedb.conf').with_content(/^PRUNEFS = \"9p afs .*$/) }
    end
  end
end
