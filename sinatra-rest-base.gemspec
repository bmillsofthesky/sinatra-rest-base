# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_base/version'

Gem::Specification.new do |spec|
  spec.name          = 'sinatra-rest-base'
  spec.version       = RestBase::VERSION
  spec.authors       = ['Brandon Mills']
  spec.email         = ['brandon.mills1123@gmail.com']
  spec.summary       = %q{Base class for quickly setting up RESTful services through Sinatra.}
  spec.description   = %q{Underlying framework to handle standardization of RESTful services written in the Ruby language.}
  spec.homepage      = 'https://github.com/bmillsofthesky/sinatra-rest-base'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.1'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'json', '~> 2.2.0'
  spec.add_dependency 'sinatra', '~> 1.4.8'
  spec.add_dependency 'thin', '~> 1.7.2'
  spec.add_dependency 'activesupport', '~> 5.2.2'
  spec.add_dependency 'builder', '~> 3.2.3'
  spec.add_dependency 'sinatra-cross_origin', '~> 0.4.0'
  spec.add_dependency 'newrelic_rpm', '~> 6.1.0'
  spec.add_dependency 'json-schema', '~> 2.8.1'
  spec.add_dependency 'aws-sdk', '~> 3.0.1'

  spec.add_development_dependency 'rake', '~> 12.3.2'
  spec.add_development_dependency 'rack-test', '~> 1.1.0'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.1'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'rubocop', '~> 0.65.0'
  spec.add_development_dependency 'rspec-pride', '~> 3.2.1'
  spec.add_development_dependency 'guard', '~> 2.15.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
end
