require 'spec_helper'

describe 'mlocate' do

  context 'with defaults for all parameters' do
    it { should contain_class('mlocate') }
    it { should contain_class('mlocate::install') }
    it { should contain_class('mlocate::cron') }
  end
end
