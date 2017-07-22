# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maas/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'maas-client'
  spec.version       = Maas::Client::VERSION
  spec.authors       = ['Don Draper']
  spec.email         = ['donoldfashioned@gmail.com']

  spec.summary       = 'A client library for MAAS'
  spec.description   = 'A client library that can be used to call MAAS API.'
  spec.homepage      = 'https://github.com/itisnotdone/maas-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['rbmaas']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.3.1'

  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'simplecov', '~> 0.13.0'
  spec.add_development_dependency 'fivemat', '~> 1.3'
  spec.add_development_dependency 'cane', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.1'

  spec.add_runtime_dependency 'oauth', '~> 0.5.1'
  spec.add_runtime_dependency 'json', '~> 2.1.0'
  spec.add_runtime_dependency 'thor', '~> 0.19.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.2.8'
end
