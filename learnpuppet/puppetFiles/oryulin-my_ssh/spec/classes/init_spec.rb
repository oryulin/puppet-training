require 'spec_helper'
describe 'my_ssh' do

  context 'with defaults for all parameters' do
    it { should contain_class('my_ssh') }
  end
end
