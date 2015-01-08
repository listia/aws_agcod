# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_agcod/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_agcod"
  spec.version       = AwsAgcod::VERSION
  spec.authors       = ["Xenor Chang"]
  spec.email         = ["xenor@listia.com"]
  spec.summary       = %q{AWS AGCOD API v2 endpoints implementation}
  spec.description   = %q{Amazon Gift Code On Demand (AGCOD) API v2 implementation for
                          distribute Amazon gift cards (gift codes) instantly in any denomination}
  spec.homepage      = "https://github.com/listia/aws-agcod"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,spec}/**/*"].select { |f| File.file?(f) } +
                         %w(LICENSE.txt Rakefile README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.1', '>= 3.1.0'
end
