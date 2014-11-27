# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codgen/version'

Gem::Specification.new do |spec|
  spec.name          = "codgen"
  spec.version       = Codgen::VERSION
  spec.authors       = ["Matthew Beatty"]
  spec.email         = ["beattyml1@gmail.com"]
  spec.summary       = 'Generate multiple applications from a common model written in JSON using template'
  spec.description   = ''
  spec.homepage      = "https://github.com/beattyml1/codgen"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "activerecord"
end
