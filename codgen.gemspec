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
  spec.description   = "Codgen is a cross language, template based, code generator, capable of generating multiple applications from a common model. It uses JSON for it's model and config and you can use mustache or handlebars templates or just verbatim copy. If you find a bug or bad error message be sure to log an issue on GitHub."

  spec.homepage      = "https://github.com/beattyml1/codgen"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "given_when_then"
  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency 'rubyzip'
  spec.add_runtime_dependency 'handlebars', '0.6.0'
end
