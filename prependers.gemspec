# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prependers/version"

Gem::Specification.new do |spec|
  spec.name          = "prependers"
  spec.version       = Prependers::VERSION
  spec.authors       = ["Alessandro Desantis"]
  spec.email         = ["desa.alessandro@gmail.com"]

  spec.summary       = 'Easily and cleanly extend third-party code.'
  spec.homepage      = 'https://github.com/nebulab/prependers'
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "github_changelog_generator", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", '~> 0.4.1'
  spec.add_development_dependency "rubocop", '~> 0.70.0'
  spec.add_development_dependency "rubocop-performance", '~> 1.3'
  spec.add_development_dependency "rubocop-rspec", '~> 1.33'
end
