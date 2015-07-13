# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciinema/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "asciinema-rails"
  spec.version       = Asciinema::Rails::VERSION
  spec.authors       = ["Eddie Johnston"]
  spec.email         = ["eddiej@gmail.com"]
  spec.summary       = %q{Converts sudosh log files to asciinema format.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oj"
  spec.add_dependency "oj_mimic_json"
  spec.add_dependency "yajl-ruby", "~> 1.2.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
