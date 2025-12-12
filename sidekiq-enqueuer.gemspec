# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/enqueuer/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-enqueuer"
  spec.version       = Sidekiq::Enqueuer::VERSION
  spec.authors       = ["richfisher"]
  spec.email         = ["richfisher.pan@gmail.com"]

  spec.summary       = "A Sidekiq Web extension to enqueue/schedule jobs with custom perform params in Web UI."
  spec.description   = "A Sidekiq Web extension to enqueue/schedule jobs with custom perform params in Web UI. Support both Sidekiq::Worker and ActiveJob."
  spec.homepage      = "https://github.com/umbrellio/sidekiq-enqueuer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq", ">= 6.0", "< 9"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails", ">= 6.0"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "rubocop"
end

