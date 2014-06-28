require 'spec_helper'
describe 'windows_oradb' do

  context 'with defaults for all parameters' do
    it { should contain_class('windows_oradb') }
  end
end
