# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotmation/version'

Gem::Specification.new do |spec|
  spec.name          = "dotmation"
  spec.version       = Dotmation::VERSION
  spec.authors       = ["John T. Prince"]
  spec.email         = ["jtprince@gmail.com"]
  spec.description   = %q{ruby dsl/config to softlink dotfiles that is somewhat github aware}
  spec.summary       = %q{ruby dsl/config to softlink dotfiles}
  spec.homepage      = "http://github.com/jtprince/dotmation"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
