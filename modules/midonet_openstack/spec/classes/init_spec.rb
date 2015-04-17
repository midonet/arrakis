require 'spec_helper'
describe 'midonet_openstack' do

  context 'with defaults for all parameters' do
    it { should contain_class('midonet_openstack') }
  end
end
