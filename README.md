# Chef::Provider::Service::Daemontools

Chef's provider to manage service under daemontools.

You can transparently manage processes under daemontools using `service` resource.

## Installation

Add this line to your application's Gemfile:

    gem 'chef-provider-service-daemontools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-provider-service-daemontools

## Usage

```ruby
require 'chef/provider/service/daemontools'

service 'tinydns-internal' do
  provider Chef::Provider::Service::Daemontools
  service_dir '/service'
  directory '/etc/djbdns/tinydns-internal'
  supports :restart => true, :reload => true
  action [:enable, :start]
end
```

- provider (required)
    - `Chef::Provider::Service::Daemontools`
- service_dir (optional)
    - directory that svscan monitors. default is `/service`
- directory (required)
    - directory contains `run` file

## Contributing

1. Fork it ( https://github.com/hirose31/chef-provider-service-daemontools/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
