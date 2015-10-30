# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flock_synchronize/version'

Gem::Specification.new do |spec|
  spec.name          = "flock_synchronize"
  spec.version       = FlockSynchronize::VERSION
  spec.authors       = ["Rich Daley"]
  spec.email         = ["rich@fishpercolator.co.uk"]

  spec.summary       = %q{Simple synchronization between Ruby processes using flock}
  spec.description   = %q{Adds a flock_synchronize method that synchronizes code execution between processes, similar to how a Mutex works between threads.}
  spec.homepage      = "https://github.com/fishpercolator/flock_synchronize"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "parallel"
end
