# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/provider/service/daemontools/version'

Gem::Specification.new do |spec|
  spec.name          = "chef-provider-service-daemontools"
  spec.version       = Chef::Provider::Service::Daemontools::VERSION
  spec.authors       = ["HIROSE Masaaki"]
  spec.email         = ["hirose31@gmail.com"]
  spec.summary       = %q{Chef's provider to manage service under daemontools.}
  spec.description   = %q{Chef's provider to manage service under daemontools.}
  spec.homepage      = "https://github.com/hirose31/chef-provider-service-daemontools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chef"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
