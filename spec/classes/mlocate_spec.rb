require 'spec_helper'

describe 'mlocate', :type => :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'with defaults for all parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('mlocate') }
          it { should contain_class('mlocate::install') }
          it { should contain_class('mlocate::cron') }

          it { should contain_file('updatedb.conf').with_path('/etc/updatedb.conf') }
          it { should contain_file('updatedb.conf').with_content(/PRUNEPATHS = \"\/afs .*$/) }
          it { should contain_file('updatedb.conf').with_content(/PRUNEFS = \"9p afs .*$/) }
          it { should contain_file('updatedb.conf').with_content(/PRUNE_BIND_MOUNTS.*$/) }
          it { should contain_file('updatedb.conf').with_content(/PRUNENAMES.*$/) }

          it { should contain_file('update_command').with_path('/usr/local/bin/mlocate.cron') }
          it { should contain_exec('/usr/local/bin/mlocate.cron') }
        end
        context 'with update_command set and deploy_update_command true' do
          let(:params) do
            {
              update_command: '/tmp/junk',
              deploy_update_command: true
            }
          end
          it { should contain_file('update_command').with_path('/tmp/junk') }
          it { should contain_exec('/tmp/junk') }
        end
        context 'with update_command set and deploy_update_command false' do
          let(:params) do
            { update_command: '/tmp/junk',
              deploy_update_command: false }
          end
          it { should_not contain_file('update_command') }
          it { should contain_exec('/tmp/junk') }
        end
        context 'with update_command set and update_on_install false' do
          let(:params) do
            { update_command: '/tmp/junk',
              update_on_install: false }
          end
	  it { should contain_file('update_command').with_path('/tmp/junk') }
          it { should_not contain_exec('/tmp/junk') }
        end
        context 'with update_command set and update_on_install true' do
          let(:params) do
            { update_command: '/tmp/junk',
              update_on_install: true }
          end
	  it { should contain_file('update_command').with_path('/tmp/junk') }
          it { should contain_exec('/tmp/junk') }
        end
      end
    end
  end
end
