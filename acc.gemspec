# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acc/version'

Gem::Specification.new do |spec|
  spec.name          = "acc"
  spec.version       = Acc::VERSION
  spec.authors       = ["Arnaud MESUREUR"]
  spec.email         = ["arnaud.mesureur@gmail.com"]

  spec.summary       = %q{AppleCare Connect services interface}
  spec.description   = %q{Interface for the ACC Device Enrollment Program API}
  spec.homepage      = "https://github.com/nsarno/acc"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_dependency "curb"
  spec.add_dependency "activesupport"
end
