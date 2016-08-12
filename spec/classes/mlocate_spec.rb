require 'spec_helper'

describe 'mlocate' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        it { should compile.with_all_deps }

        context 'with defaults for all parameters' do
          it { should contain_class('mlocate') }
          it { should contain_class('mlocate::install') }
          it { should contain_class('mlocate::cron') }

          it { should contain_file('updatedb.conf').with_path('/etc/updatedb.conf') }
          it { should contain_file('updatedb.conf').with_content(/^PRUNEPATHS = \"\/afs .*$/) }
          it { should contain_file('updatedb.conf').with_content(/^PRUNEFS = \"9p afs .*$/) }

          if facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease] == '5' then
            it { should contain_file('updatedb.conf').without_content(/^PRUNE_BIND_MOUNTS.*$/) }
            it { should contain_file('updatedb.conf').without_content(/^PRUNENAMES.*$/) }
          else
            it { should contain_file('updatedb.conf').with_content(/^PRUNE_BIND_MOUNTS = "yes"$/) }
            it { should contain_file('updatedb.conf').with_content(/^PRUNENAMES = ".git .hg .svn"$/) }
          end
        end
      end
    end
  end
end
