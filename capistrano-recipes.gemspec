# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano_recipes/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano_recipes"
  spec.version       = CapistranoRecipes::VERSION
  spec.authors       = ["maverick"]
  spec.email         = ["maverick@ekohe.com"]
  spec.summary       = %q{Provide recipes:generate rake task}
  spec.description   = %q{Provide recipes:generate rake task to generate capistrano recipes for deployment.}
  spec.homepage      = "https://github.com/maverick9000/capistrano-recipes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.2.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
