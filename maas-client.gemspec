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

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fivemat'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'rubocop'

  spec.add_runtime_dependency 'oauth'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'typhoeus'
end
