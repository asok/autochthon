# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autochthon/version'

Gem::Specification.new do |spec|
  spec.name          = "autochthon"
  spec.version       = Autochthon::VERSION
  spec.authors       = ["Adam Sokolnicki"]
  spec.email         = ["adam.sokolnicki@gmail.com"]

  spec.summary       = %q{Sinatra app for managing I18n translations}
  spec.description   = %q{Sinatra app for managing I18n translations stored in YAML files, database or Redis}
  spec.homepage      = "https://github.com/asok/autochthon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "i18n"
end
