# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mastermind/oscar/version'

Gem::Specification.new do |spec|
  spec.name          = "mastermind-oscar"
  spec.version       = Mastermind::Oscar::VERSION
  spec.authors       = ["Oscar"]
  spec.email         = ["oskarromero3@gmail.com"]

  spec.summary       = %q{Implements the popular classic game: MASTERMIND}
  spec.description   = %q{Mastermind_Oscar is a Ruby implementation of the classic board game of same name. The game is a code breaking game between two players; in this implementation, it is between a player and the computer.}
  spec.homepage      = "https://github.com/andela-ooranagwa/mastermind-oscar.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['mastermind_oscar']
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'pry', "~> 0.10", ">= 0.10.1"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "minitest-reporters", "~> 1.1", ">= 1.1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "colorize", "~> 0.7", ">= 0.7.7"
  spec.add_development_dependency 'simplecov', "~> 0.10", ">= 0.10.0" #, require: false
end
