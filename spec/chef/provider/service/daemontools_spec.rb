require 'spec_helper'

describe Chef::Provider::Service::Daemontools do
  it 'has a version number' do
    expect(Chef::Provider::Service::Daemontools::VERSION).not_to be nil
  end
end
